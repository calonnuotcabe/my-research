#include <linux/cdev.h>
#include <linux/fs.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <asm/processor.h>
#include <asm/uaccess.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Huhu");
MODULE_DESCRIPTION("Holstein v1 stack overflow for the kROP lesson");

#define DEVICE_NAME "holstein"
#define BUFFER_SIZE 0x400
#define SMEP_BIT (1UL << 20)

static char *g_buf;
static dev_t dev_id;
static struct cdev c_dev;

static int module_open(struct inode *inode, struct file *file)
{
    printk(KERN_INFO "module_open called\n");

    g_buf = kmalloc(BUFFER_SIZE, GFP_KERNEL);
    if (!g_buf) {
        printk(KERN_INFO "kmalloc failed\n");
        return -ENOMEM;
    }

    return 0;
}

static ssize_t module_read(
    struct file *file,
    char __user *buf,
    size_t count,
    loff_t *f_pos
)
{
    char kbuf[BUFFER_SIZE] = { 0 };

    printk(KERN_INFO "module_read called\n");

    memcpy(kbuf, g_buf, BUFFER_SIZE);

    /* Intentional stack overflow: count is not bounded. */
    if (copy_to_user(buf, kbuf, count)) {
        printk(KERN_INFO "copy_to_user failed\n");
        return -EINVAL;
    }

    return count;
}

static ssize_t module_write(
    struct file *file,
    const char __user *buf,
    size_t count,
    loff_t *f_pos
)
{
    char kbuf[BUFFER_SIZE] = { 0 };

    printk(KERN_INFO "module_write called\n");

    /* Intentional stack overflow: count is not bounded. */
    if (copy_from_user(kbuf, buf, count)) {
        printk(KERN_INFO "copy_from_user failed\n");
        return -EINVAL;
    }

    memcpy(g_buf, kbuf, BUFFER_SIZE);
    return count;
}

static int module_close(struct inode *inode, struct file *file)
{
    printk(KERN_INFO "module_close called\n");
    kfree(g_buf);
    g_buf = NULL;
    return 0;
}

static struct file_operations module_fops = {
    .owner = THIS_MODULE,
    .read = module_read,
    .write = module_write,
    .open = module_open,
    .release = module_close,
};

static int __init module_initialize(void)
{
    int ret;
    unsigned long cr4;

    ret = alloc_chrdev_region(&dev_id, 0, 1, DEVICE_NAME);
    if (ret) {
        printk(KERN_WARNING "Failed to register device\n");
        return ret;
    }

    cdev_init(&c_dev, &module_fops);
    c_dev.owner = THIS_MODULE;

    ret = cdev_add(&c_dev, dev_id, 1);
    if (ret) {
        printk(KERN_WARNING "Failed to add cdev\n");
        unregister_chrdev_region(dev_id, 1);
        return ret;
    }

    /* The lesson has SMEP enabled, so userland ret2usr must not work. */
    cr4 = read_cr4();
    write_cr4(cr4 | SMEP_BIT);
    printk(KERN_INFO "holstein kROP: SMEP enabled, CR4=0x%lx\n", read_cr4());

    printk(
        KERN_INFO "holstein registered: major=%d minor=%d\n",
        MAJOR(dev_id),
        MINOR(dev_id)
    );

    return 0;
}

static void __exit module_cleanup(void)
{
    cdev_del(&c_dev);
    unregister_chrdev_region(dev_id, 1);
}

module_init(module_initialize);
module_exit(module_cleanup);
