# Hypervisor Exploitation
> Bad memory with hypervisor

### Overview

Well, have to say that i wrote this note after failing a course in my uni:(((

Because i hate myself so i decided to learn about hypervisor exploitation. Anyway, i found a qemu-challenge for beginner, so this challenge will be my very first step in my journey. We have the source code in `maria.c`:

```c
#include "hw/hw.h"
#include "hw/pci/msi.h"
#include "hw/pci/pci.h"
#include "qapi/visitor.h"
#include "qemu/main-loop.h"
#include "qemu/module.h"
#include "qemu/osdep.h"
#include "qom/object.h"

#define TYPE_PCI_MARIA_DEVICE "maria"
#define MARIA_MMIO_SIZE 0x10000

#define BUFF_SIZE 0x2000

typedef struct {
    PCIDevice pdev;
    struct {
                uint64_t src;
        uint8_t off;
        } state;
    char buff[BUFF_SIZE];
    MemoryRegion mmio;
} MariaState;

DECLARE_INSTANCE_CHECKER(MariaState, MARIA, TYPE_PCI_MARIA_DEVICE)

static uint64_t maria_mmio_read(void *opaque, hwaddr addr, unsigned size) {
    MariaState *maria = (MariaState *)opaque;
    uint64_t val = 0;
    switch (addr) {
        case 0x00:
            cpu_physical_memory_rw(maria->state.src, &maria->buff[maria->state.off], BUFF_SIZE, 1);
            val = 0x600DC0DE;
            break;
        case 0x04:
            val = maria->state.src;
            break;
        case 0x08:
            val = maria->state.off;
            break;
        default:
            val = 0xDEADC0DE;
            break;
    }
    return val;
}

static void maria_mmio_write(void *opaque, hwaddr addr, uint64_t val, unsigned size) {
    MariaState *maria = (MariaState *)opaque;
    switch (addr) {
        case 0x00:
            cpu_physical_memory_rw(maria->state.src, &maria->buff[maria->state.off], BUFF_SIZE, 0);
            break;
        case 0x04:
            maria->state.src = val;
            break;
        case 0x08:
            maria->state.off = val;
            break;
        default:
            break;
    }
}

static const MemoryRegionOps maria_mmio_ops = {
    .read = maria_mmio_read,
    .write = maria_mmio_write,
    .endianness = DEVICE_NATIVE_ENDIAN,
    .valid = {
        .min_access_size = 4,
        .max_access_size = 4,
    },
    .impl = {
        .min_access_size = 4,
        .max_access_size = 4,
    },
};

static void pci_maria_realize(PCIDevice *pdev, Error **errp) {
    MariaState *maria = MARIA(pdev);
    memory_region_init_io(&maria->mmio, OBJECT(maria), &maria_mmio_ops, maria, "maria-mmio", MARIA_MMIO_SIZE);
    pci_register_bar(pdev, 0, PCI_BASE_ADDRESS_SPACE_MEMORY, &maria->mmio);
}

static void maria_instance_init(Object *obj) {
    MariaState *maria = MARIA(obj);
    memset(&maria->state, 0, sizeof(maria->state));
    memset(maria->buff, 0, sizeof(maria->buff));
}

static void maria_class_init(ObjectClass *class, void *data) {
    DeviceClass *dc = DEVICE_CLASS(class);
    PCIDeviceClass *k = PCI_DEVICE_CLASS(class);

    k->realize = pci_maria_realize;
    k->vendor_id = PCI_VENDOR_ID_QEMU;
    k->device_id = 0xDEAD;
    k->revision = 0x0;
    k->class_id = PCI_CLASS_OTHERS;

    set_bit(DEVICE_CATEGORY_MISC, dc->categories);
}

static void pci_maria_register_types(void) {
    static InterfaceInfo interfaces[] = {
        { INTERFACE_CONVENTIONAL_PCI_DEVICE },
        { },
    };
    static const TypeInfo maria_info = {
        .name = TYPE_PCI_MARIA_DEVICE,
        .parent = TYPE_PCI_DEVICE,
        .instance_size = sizeof(MariaState),
        .instance_init = maria_instance_init,
        .class_init = maria_class_init,
        .interfaces = interfaces,
    };

    type_register_static(&maria_info);
}

type_init(pci_maria_register_types)
```
So i will try to understand what happened behind these code and figured out how you supposed to solve this challenge.

### Reading The Code

#### The QEMU FLOW

##### What a pci dev usually have

A pci dev usually has the flow like this: </br>

```c
#define TYPE_PCI_MARIA_DEVICE "maria"

typedef struct MariaState {
    PCIDevice pdev;       // a struct that has all the information a pci dev should has

    MemoryRegion mmio;    // memory-mapped-i/o (a memory for the dev)

    uint8_t buff[0x1000]; // buffer
    uint64_t src;         // physical address of the guest
    uint64_t off;         // virtual address of the guest
} MariaState;

DECLARE_INSTANCE_CHECKER(
    MariaState,           // The target struct
    MARIA,                // The output helper 
    TYPE_PCI_MARIA_DEVICE // the device name
)
```

deviceRegister: </br>

```c
static const TypeInfo pci_maria_info = {
    .name          = TYPE_PCI_MARIA_DEVICE,
    .parent        = TYPE_PCI_DEVICE,
    .instance_size = sizeof(MariaState),
    .instance_init = maria_instance_init,
    .class_init    = maria_class_init,
};

static void pci_maria_register_types(void)
{
    type_register_static(&pci_maria_info);
}

type_init(pci_maria_register_types);
```

class: </br>

```c
static void maria_class_init(ObjectClass *klass, void *data)
{
    DeviceClass *dc = DEVICE_CLASS(klass);
    PCIDeviceClass *k = PCI_DEVICE_CLASS(klass);

    k->realize = pci_maria_realize;

    k->vendor_id = 0x1234;
    k->device_id = 0xdead;
    k->class_id  = PCI_CLASS_OTHERS;

    dc->desc = "Maria PCI Device";
}
```
instanceCreate: </br>

```c
static void maria_instance_init(Object *obj)
{
    MariaState *maria = MARIA(obj);

    maria->src = 0;
    maria->off = 0;

    memset(maria->buff, 0, sizeof(maria->buff));
}
```

realize: </br>

```c
static void pci_maria_realize(
    PCIDevice *pdev,
    Error **errp
)
{
    MariaState *maria = MARIA(pdev);

    memory_region_init_io(
        &maria->mmio,
        OBJECT(maria),
        &maria_mmio_ops,
        maria,
        "maria-mmio",
        0x10000
    );

    pci_register_bar(
        pdev,
        0,
        PCI_BASE_ADDRESS_SPACE_MEMORY,
        &maria->mmio
    );
}
```

When QEMU init:</br>
It read `type_init(pci_maria_register_types);` </br>
And `pci_maria_register_types` being run: </br>

```c
static void pci_maria_register_types(void) {
    static InterfaceInfo interfaces[] = {
        { INTERFACE_CONVENTIONAL_PCI_DEVICE },
        { },
    };
    static const TypeInfo maria_info = {
        .name = TYPE_PCI_MARIA_DEVICE,
        .parent = TYPE_PCI_DEVICE,
        .instance_size = sizeof(MariaState),
        .instance_init = maria_instance_init,
        .class_init = maria_class_init,
        .interfaces = interfaces,
    };

    type_register_static(&maria_info);
}
```

and it called `type_register_static(&maria_info);` we already declare `maria_info` in `pci_maria_register_types`: </br>

```c
static InterfaceInfo interfaces[] = {
    {
        /*
         * Declares that Maria implements the conventional PCI device
         * interface.
         */
        INTERFACE_CONVENTIONAL_PCI_DEVICE
    },

    /*
     * Empty sentinel marking the end of the interface array.
     */
    { },
};

static const TypeInfo maria_info = {
    /*
     * The QOM type name.
     *
     * When QEMU receives:
     *
     *     -device maria
     *
     * it searches for a registered type named "maria".
     */
    .name = TYPE_PCI_MARIA_DEVICE,

    /*
     * The parent QOM type.
     *
     * Maria inherits the behavior and structure of a PCI device.
     */
    .parent = TYPE_PCI_DEVICE,

    /*
     * The amount of memory QEMU allocates for each Maria instance.
     */
    .instance_size = sizeof(MariaState),

    /*
     * Called once for every Maria object that QEMU creates.
     *
     * It initializes instance-specific state such as state.src,
     * state.off, and buff.
     */
    .instance_init = maria_instance_init,

    /*
     * Called when QEMU initializes the Maria class.
     *
     * It configures properties shared by all Maria instances,
     * such as the realize callback, PCI vendor ID, device ID,
     * revision, and class ID.
     */
    .class_init = maria_class_init,

    /*
     * Lists the QOM interfaces implemented by Maria.
     */
    .interfaces = interfaces,
};
```
After the type "maria" being create/init, `maria_class_init()` being run: </br>

```c
static void maria_class_init(ObjectClass *klass, void *data)
{
    DeviceClass *dc = DEVICE_CLASS(klass);
    PCIDeviceClass *k = PCI_DEVICE_CLASS(klass);

    k->realize = pci_maria_realize; 
    /*
     * When a Maria pci dev is realized, call pci_maria_realize
     */

    k->vendor_id = 0x1234;
    k->device_id = 0xdead;
    /*
    00:05.0 Class 00ff: 1234(vendor id) :dead (dev id)
    */

    k->class_id  = PCI_CLASS_OTHERS;

    dc->desc = "Maria PCI Device";
    //description
}
```

if run.sh has the command `-device maria` => In QOM registry, QEMU found `.name = "maria"` => Allocate sizeof(MariaState) => Create Maria object => Call maria_instance_init() </br>

In `maria_instance_init()`: </br>

```c
static void maria_instance_init(Object *obj)
{
    MariaState *maria = MARIA(obj);

    maria->src = 0;  
    maria->off = 0;

    memset(maria->buff, 0, sizeof(maria->buff));
}
```

When maria being realized, `pci_maria_realize(pdev, errp);` will be called: </br>

```c
static void pci_maria_realize(PCIDevice *pdev, Error **errp) {
    MariaState *maria = MARIA(pdev);
    memory_region_init_io(
        &maria->mmio,     //memory-mapped-i/o
        OBJECT(maria),    //owner of the memory region
        &maria_mmio_ops,  //callback operations
        maria,            //opaque for the maria instance
        "maria-mmio",     //region name
        MARIA_MMIO_SIZE   //size
        );
    //Create a memoryRegion:
    pci_register_bar(pdev, 0, PCI_BASE_ADDRESS_SPACE_MEMORY, &maria->mmio); //maria->mmio is attached to BAR0
}
```
Operations when you write/read the device: </br>
```c
static const MemoryRegionOps maria_mmio_ops = {
    .read = maria_mmio_read,  
    .write = maria_mmio_write,
    .endianness = DEVICE_NATIVE_ENDIAN,
    .valid = {
        .min_access_size = 4,
        .max_access_size = 4,
    },
    .impl = {
        .min_access_size = 4,
        .max_access_size = 4,
    },
};

```

Hierarchy: </br>
```
Instance:
Object → DeviceState → PCIDevice → MariaState

Class:
ObjectClass → DeviceClass → PCIDeviceClass → Maria class
```

