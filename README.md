# Board Support Layer Guidelines

---

These Guidelines standardize the format/layout of a layer containing
hardware or board support files and recipes (BSP-Layer).

---

## A Board Support Layer 
### ... should include
  * MACHINE file
  * Bootloader
  * Kernel
  * Configuration files
  * Board specific adaptations
  * Firmware (optional)
  * EULA (if needed)
  * README

### MACHINE file
The main configuration file and essential to a Board Support Layer is
the MACHINE file. It is expected in the folder "conf/machine/_boardname_.conf".
_boardname_ is then what is set as MACHINE = "_boardname_" in the conf/local.conf.

### Bootloader / Bootfiles
All files, procedures and recipes necessary to bring the CPU out of
reset and load the kernel image. If possible multiple boot-media
should be supported (SD/MMC/eMMC, TFTP, USB).
Also included should be a document describing the commands necessary
to deploy and use the bootloader.

### Kernel recipe
There are multiple options how this can be accomplished. The following
list can be seen as recommendation and starts with the approach that
reuses as much as possible (minimizing your maintenance) and ends with
the approach of max customizability (with all work to be done by you).
  1. Extend the already provided kernel recipe. As example, the
     Yocto Project provides a maintained and stable Linux Kernel
     series through the recipe "linux-yocto". The recipe is already
     capable of supporting multiple devices out of a single git tree.
     Ideally you would create a machine branch and a bbappend
     and reuse the updates done to the base branch.
    * Pros:
      * shared maintenance
      * stable kernel tree (multiple versions)
      * part of the reference distro
      * tooling of the project can be reused (e.g. tempates for yocto-kernel)
    * Cons:
      * shared workflow/structure needs to be used
      * initial learning curve and patch-porting (one-time)
  2. Use the kernel bbclass (inherit kernel) create your own custom kernel recipe.
     Kernel recipes can be quite straightforward as we need mainly three
     ingredients: Kernel Sources, Patches and a default configuration.
     This can be handled by the existing kernel.bbclass perfectly fine.
     Depending on the amount of patches needed, this can lead to
     a lot of work forward-porting your patches in the mid/long run.
    * Pros:
      * easy to get started
      * full control of patches applied to kernel tree
    * Cons:
      * no shared maintenance
      * security updates / maintenance per board
      * patch queue must be forward-ported per board
      * no reuse of tooling possible

### Configuration files
A BSP-Layer also needs to include the necessary configuration files
(e.g. xorg, wayland/weston) for the board. Reuse the existing recipes
using the bbappend mechanism and __do not reinvent the wheel__ as this
will cause trouble with every upgrade/migration.

Keep in mind how bitbake handles append files and how immediate and
late expansion influences the recipes.
Especially the xorg.conf bbappends are a well known source of breakage due
to bitbake's immediate expansion.

### Board specific adaptations
Adaptations should also reuse the existing recipes and only derive from
this rule if no other way exists. __Do not reinvent the wheel__.
This also means to use the library version of the OE/Yocto release in use.
The append mechanism is to be used to inject the adaptations.
Keep your adaptations small and use the _conditional variables_ (__OVERRIDES__)
as much as possible. __Ideally your changes would only be effective if
your board is selected as MACHINE__. 

### Firmware (optional)
All necessary firmware files to boot and operate the board need to be included
in the BSP-Layer and need to be released under license that at least
allows (binary) distribution.

### EULA (if required)
For commercially supported Layers an EULA can be added and enforced within the
build procedure as activating a variable in conf/local.conf.

### README(.md)
A proper README needs to be included and should contain:
  * Maintainer(s), email(s), contact info
  * Build instructions for core-image-*
  * Flashing/installation process and tools

## A Board Support Layer needs to:

### Reuse the branching scheme of the OE/YP release cycles
It is essential for users of a BSP to be able to match the
right set of layers together based on their OE/YP release.
Thus especially BSP layers need to track the OE/YP release branches.

### __DO NOT__ modify DISTRO_* variable
A __Board Support__ Layer is means that only hardware support
recipes are to be included there. DISTRO_* variables and
other global settings (DEFAULTTUNE) should only be set
using the (late) default value ("??=")"?=" assignment.
This is because these options are supposed to be set by
the distribution or the user. Otherwise there is no reuse
possible across platforms.

### Do not include non-essential recipes ###
The BSP should provide the hardware abstraction and allow the system
to boot. Non-essential recipes should be in a separate layer as
the BSP layer should be small and target only the hardware support.
This ensures simpler migration and reusablilty.


