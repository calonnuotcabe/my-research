#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/cdev.h>
#include <linux/fs.h>
#include <linux/ioctl.h>
#include <linux/uaccess.h>
#include <linux/slab.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("ptr-yudai");
MODULE_DESCRIPTION("Holstein v2 - ioctl user/kernel boundary lab");

#define DEVICE_NAME "holstein"
#define BUFFER_SIZE 0x400

struct holstein_request {
  __u64 user_buf;
  __u64 length;
};

#define HOLSTEIN_IOCTL_COPY \
  _IOW('H', 0x01, struct holstein_request)

static char *g_buf;

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

static ssize_t module_read(struct file *file,
                           char __user *buf, size_t count,
                           loff_t *f_pos)
{
  char kbuf[BUFFER_SIZE] = { 0 };

  printk(KERN_INFO "module_read called\n");

  memcpy(kbuf, g_buf, BUFFER_SIZE);
  if (_copy_to_user(buf, kbuf, count)) {
    printk(KERN_INFO "copy_to_user failed\n");
    return -EINVAL;
  }

  return count;
}

/*
 * Deliberately vulnerable sink.  Keeping this function identical in shape to
 * the previous write path makes the new lesson about ioctl ABI, not a new
 * stack-layout puzzle.
 */
static ssize_t module_write(struct file *file,
                            const char __user *buf, size_t count,
                            loff_t *f_pos)
{
  char kbuf[BUFFER_SIZE] = { 0 };

  printk(KERN_INFO "module_write called\n");

  if (_copy_from_user(kbuf, buf, count)) {
    printk(KERN_INFO "copy_from_user failed\n");
    return -EINVAL;
  }
  memcpy(g_buf, kbuf, BUFFER_SIZE);

  return count;
}

static long module_ioctl(struct file *file,
                         unsigned int cmd, unsigned long arg)
{
  struct holstein_request req;

  printk(KERN_INFO "module_ioctl called\n");

  if (cmd != HOLSTEIN_IOCTL_COPY)
    return -EINVAL;

  if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
    return -EFAULT;

  printk(KERN_INFO "ioctl request: user_buf=0x%llx length=0x%llx\n",
         req.user_buf, req.length);

  /* The request controls both a user pointer and the copy length. */
  return module_write(file,
                      (const char __user *)(unsigned long)req.user_buf,
                      (size_t)req.length,
                      NULL);
}

static int module_close(struct inode *inode, struct file *file)
{
  printk(KERN_INFO "module_close called\n");
  kfree(g_buf);
  g_buf = NULL;
  return 0;
}

static const struct file_operations module_fops = {
  .owner          = THIS_MODULE,
  .read           = module_read,
  .write          = module_write,
  .unlocked_ioctl = module_ioctl,
  .open           = module_open,
  .release        = module_close,
};

static dev_t dev_id;
static struct cdev c_dev;

static int __init module_initialize(void)
{
  if (alloc_chrdev_region(&dev_id, 0, 1, DEVICE_NAME)) {
    printk(KERN_WARNING "Failed to register device\n");
    return -EBUSY;
  }

  printk(KERN_WARNING "holstein ioctl device: major=%u minor=%u\n",
         MAJOR(dev_id), MINOR(dev_id));

  cdev_init(&c_dev, &module_fops);
  c_dev.owner = THIS_MODULE;

  if (cdev_add(&c_dev, dev_id, 1)) {
    printk(KERN_WARNING "Failed to add cdev\n");
    unregister_chrdev_region(dev_id, 1);
    return -EBUSY;
  }

  printk(KERN_WARNING "holstein ioctl device: cdev added\n");

  return 0;
}

static void __exit module_cleanup(void)
{
  cdev_del(&c_dev);
  unregister_chrdev_region(dev_id, 1);
}

module_init(module_initialize);
module_exit(module_cleanup);
