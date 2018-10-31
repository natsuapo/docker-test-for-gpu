# A memo for building environment for different GPU via docker

## find out the graphic card type: 
```
user@user-desktop:~$ sudo lshw -C display
  *-display               
       description: VGA compatible controller
       product: Advanced Micro Devices, Inc. [AMD/ATI]
       vendor: Advanced Micro Devices, Inc. [AMD/ATI]
```

```
user@user-desktop:~$ lspci | grep ' VGA ' | cut -d" " -f 1 | xargs -i lspci -v -s {}
01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Device 67df (rev ef) (prog-if 00 [VGA controller])
	Subsystem: ASRock Incorporation Device 5001
	Flags: bus master, fast devsel, latency 0, IRQ 144
	Memory at c0000000 (64-bit, prefetchable) [size=256M]
	Memory at d0000000 (64-bit, prefetchable) [size=2M]
	I/O ports at e000 [size=256]
	Memory at dfe00000 (32-bit, non-prefetchable) [size=256K]
	Expansion ROM at 000c0000 [disabled] [size=128K]
	Capabilities: <access denied>
	Kernel driver in use: amdgpu
	Kernel modules: amdgpu

```




## install the grpahic card driver: 
### Process of installing AMD graphic board driver: 
References:
qiita tutorial: https://qiita.com/kz_lil_fox/items/d1a18f58e9e5033e7e14  
github: https://github.com/RadeonOpenCompute/ROCm-docker/blob/master/quick-start.md  

### install docker
References: 
https://qiita.com/tkyonezu/items/0f6da57eb2d823d2611d

### install and run docker container
Build ROCm container using docker cli: follows the github tutorial: https://github.com/RadeonOpenCompute/ROCm-docker/blob/master/quick-start.md  








### Process of installing Nvidia graphic board driver: 
GTX-1070
GTX-1080
GTX-2080






