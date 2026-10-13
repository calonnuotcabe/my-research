#include <linux/module.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/moduleparam.h>
#include <linux/stat.h>

static int hehe __initdata = 3;

static int myint = 430;
static short int myshort = 1;
static long int mylong = 9999;
static char *mystring = "huhu";
static int myintArray[2] = {-1, -1};
static int arr_argc = 0;

module_param(myshort, short, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP);
MODULE_PARM_DESC(myshort, "A short integer");
module_param(myint, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
MODULE_PARM_DESC(myint, "heheheh");
module_param(mylong, long, S_IRUSR);
MODULE_PARM_DESC(mylong, "huhuhuhu");
module_param(mystring, charp, 0000);
MODULE_PARM_DESC(mystring, "hehehe");
module_param_array(myintArray, int, &arr_argc, 0000);
MODULE_PARM_DESC(myintArray, "An array of intergers");

static int __init my_kernel_init(void)
 {
	int i;
	pr_info("==================\n");
	pr_info("Hello!!!\n");
	pr_info("Thanks for coming!!\n");
	pr_info("==================\n");
	pr_info("Your number info is %d\n", hehe);
	pr_info("%d\n",myint);
	pr_info("%hd\n",myshort);
	pr_info("%ld\n",mylong);
	pr_info("%s\n", mystring);
	for (i = 0; i <(sizeof myintArray / sizeof (int)); i++)
    {
		pr_info("myintArray[%d] = %d\n", i, myintArray[i]);
	}
	pr_info("got %d arg for myintArray.\n", arr_argc);
	return 0;
}
static void __exit my_kernel_exit(void) {
	pr_info("==================\n");
	pr_info("Goodbye\n");
	pr_info("Have a good time!!!\n");
	pr_info("==================\n");
}

module_init(my_kernel_init);
module_exit(my_kernel_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("huhu");
