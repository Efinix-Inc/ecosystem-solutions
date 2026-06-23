if lsmod | grep -q pcie_dma; then
    sudo rmmod pcie_dma.ko
fi
if lsmod | grep -q i2c_i801; then
    sudo rmmod i2c_i801
fi

if [ -z $1 ];
then
   sudo insmod pcie_dma.ko intr=1 poll=0
else
   sudo insmod pcie_dma.ko intr=$1 poll=0
fi
