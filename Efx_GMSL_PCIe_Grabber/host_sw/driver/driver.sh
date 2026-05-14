if lsmod | grep -q pcie_dma; then
    sudo rmmod pcie_dma.ko
fi
if lsmod | grep -q i2c_i801; then
    sudo rmmod i2c_i801
fi

sudo insmod pcie_dma.ko interrupt_mode=2