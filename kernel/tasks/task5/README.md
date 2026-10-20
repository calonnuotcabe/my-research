# Task 5 — LK01 KASLR leak

Resource gốc:

`/home/huhu/pwn-labs/resource/kernel/notes/LKE/LK01/HolsteinV1/README.md`

Phần đang học là **Avoiding KASLR**, sau ret2usr, kernel ROP và KPTI
trampoline. Đây vẫn là Holstein v1 với stack overflow; điểm mới của bài là
địa chỉ kernel thay đổi sau mỗi lần boot.

## Mục tiêu

Tự viết `solve.c` để:

```text
đọc leak từ module_read
        ↓
nhận một kernel text pointer
        ↓
tính kernel_base
        ↓
rebase symbol/gadget theo kernel_base
        ↓
kernel-only ROP
        ↓
KPTI trampoline
        ↓
shell root trong guest
```

Điều kiện qua duy nhất:

```text
/ # id
uid=0(root) gid=0(root)
```

Boot thành công, module load thành công, leak nhìn có vẻ hợp lệ, hoặc agent
self-test không tính là solve của Huhu.

## Mitigation contract

| Mitigation | Trạng thái | Ý nghĩa với bài |
|---|---|---|
| SMEP | bật | không chạy shellcode userspace từ kernel |
| SMAP | bật | không dùng user pointer như kernel data tùy tiện |
| PTI/KPTI | bật | phải dùng đường return có đổi CR3 |
| KASLR | bật | không được dùng runtime kernel address hardcode |
| NX | bật | dùng ROP, không chạy stack |

Kernel static symbols nằm trong `vmlinux`. Địa chỉ trong ELF là offset theo
image tĩnh; địa chỉ runtime phải được tính lại sau leak.

## Vulnerability contract

Module/device:

```text
module: vuln.ko
device: /dev/holstein
```

Global state:

```c
#define BUFFER_SIZE 0x400
char *g_buf;
```

`module_open()` cấp một vùng `kmalloc(0x400)` và gán vào `g_buf`. Vùng này do
module sở hữu, sống từ `open()` tới `close()`.

Trong `module_read()`:

```text
char kbuf[0x400]          // kernel stack, local object
memcpy(kbuf, g_buf, 0x400)
_copy_to_user(user_buf, kbuf, count)
```

Trong `module_write()`:

```text
char kbuf[0x400]          // kernel stack, local object
_copy_from_user(kbuf, user_buf, count)
memcpy(g_buf, kbuf, 0x400)
```

`count` không được giới hạn trước khi copy vào `kbuf`. Với build này, saved RIP
nằm sau vùng input khoảng `0x408` byte; mày phải tự xác nhận bằng source,
pattern/GDB hoặc crash log, không chỉ tin con số.

| Operation | Input | Kernel side effect | Primitive |
|---|---|---|---|
| `open` | path `/dev/holstein` | cấp `g_buf` | tạo state |
| `read` | user buffer + count | copy stack ra userspace | leak |
| `write` | user buffer + count | ghi đè stack local | control saved RIP |
| `close` | fd | `kfree(g_buf)` | kết thúc lifetime |

## Điều mày phải tự chứng minh

1. Leak lấy từ `read()` có một địa chỉ thuộc kernel text, không phải heap hay
   userspace.
2. Leak thay đổi giữa các lần boot khi KASLR bật.
3. Từ địa chỉ leak, mày tính được `kernel_base` và kiểm tra nó hợp lệ.
4. Các symbol/gadget dùng cho ROP đều là `kernel_base + offset_tĩnh`.
5. ROP vẫn dùng logic kernel-only của bài trước: tạo/commit root credential,
   sau đó quay về userland bằng KPTI trampoline.
6. Không dùng địa chỉ runtime hardcode, không dùng ret2usr, không tắt SMEP,
   SMAP hoặc KPTI.

Không cần chép nguyên exploit của LKE. Không cần dùng `ioctl` ở bài này.

## Artifact phải tự viết

```text
task5/solve.c
task5/initramfs-root/solve
```

Nên tách flow thành các hàm:

```c
save_state();
open_device();
leak_kernel_pointer();
resolve_kernel_base();
build_kernel_rop();
trigger();
get_shell();
```

Log ít nhất:

```text
leak
kernel_base
địa chỉ runtime của prepare/commit hoặc init_cred
địa chỉ runtime của gadget KPTI
write/read return value
```

## Setup/build/run

Từ đúng thư mục bài:

```sh
cd /home/huhu/my-research/kernel/tasks/task5

# Sau khi tự viết solve.c:
clang -Wall -Wextra -O0 -g -static -masm=intel solve.c -o solve
cp solve initramfs-root/solve
./setup.sh
./run.sh
```

Nếu dùng GCC:

```sh
gcc -Wall -Wextra -O0 -g -static -masm=intel solve.c -o solve
cp solve initramfs-root/solve
./setup.sh
./run.sh
```

## Debug

Terminal 1:

```sh
cd /home/huhu/my-research/kernel/tasks/task5
./debug.sh
```

Terminal 2:

```sh
cd /home/huhu/my-research/kernel/tasks/task5
gdb -q ./vmlinux
```

Trong GDB:

```gdb
target remote :1234
continue
```

Khi đã dừng ở crash hoặc breakpoint hợp lệ:

```gdb
info registers
x/24gx $rsp
```

Địa chỉ trong `vmlinux` là địa chỉ tĩnh. Với KASLR, đừng đặt breakpoint runtime
theo địa chỉ tĩnh trước khi biết base.

## Checkpoints

```text
C0_BOOT      guest lên, uid=1337, /dev/holstein tồn tại
C1_LEAK      read() trả leak kernel text ổn định
C2_BASE      tính được kernel_base từ leak
C3_REBASE    gadget/symbol runtime khớp base hiện tại
C4_CONTROL   kernel RIP đi vào ROP, không rơi vào userspace
C5_RETURN    KPTI trampoline đưa execution về solve.c
C6_ROOT      id trả uid=0(root)
```

Chỉ `C6_ROOT` là qua bài. Khi xong, gửi `solve.c` và log có leak, base,
`id`; tao sẽ review, chưa tự đánh dấu trước output của mày.
