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

## install docker
References: 
https://qiita.com/tkyonezu/items/0f6da57eb2d823d2611d


## install the grpahic card driver: 
### Process of installing AMD graphic board driver: 
References:
qiita tutorial: https://qiita.com/kz_lil_fox/items/d1a18f58e9e5033e7e14  
github: https://github.com/RadeonOpenCompute/ROCm-docker/blob/master/quick-start.md  

### install and run docker container
Build ROCm container using docker cli: follows the github tutorial: https://github.com/RadeonOpenCompute/ROCm-docker/blob/master/quick-start.md  

### install docker for tensorflow-rocm: follow this URL:
https://github.com/ROCmSoftwarePlatform/tensorflow-upstream

### get into the tensorflow enviornment: (this step should be improved.)
#### Run docker with port 8888 open:
```
drun -p 8888:8888 rocm/tensorflow
```

#### Install and run jupyter notebook: 
```
pip3 install jupyter
jupyter notebook --allow-root 
```

#### Check the GPU driver has been installed:
```
from tensorflow.python.client import device_lib
device_lib.list_local_devices()

[name: "/device:CPU:0"
 device_type: "CPU"
 memory_limit: 268435456
 locality {
 }
 incarnation: 10603528790427554674, name: "/device:GPU:0"
 device_type: "GPU"
 memory_limit: 7905424180
 locality {
   bus_id: 2
   numa_node: 1
   links {
   }
 }
 incarnation: 16877818387712764233
 physical_device_desc: "device: 0, name: Device 67df, pci bus id: 0000:01:00.0"]

```

#### install and run keras mnist model: 
```
pip3 install keras
```

benchmark code can be found in https://github.com/keras-team/keras/blob/master/examples/mnist_cnn.py

Running the benchmark to see the result: 
```
x_train shape: (60000, 28, 28, 1)
60000 train samples
10000 test samples
Train on 60000 samples, validate on 10000 samples
Epoch 1/12
60000/60000 [==============================] - 20s 327us/step - loss: 0.2741 - acc: 0.9153 - val_loss: 0.0691 - val_acc: 0.9777
Epoch 2/12
60000/60000 [==============================] - 9s 146us/step - loss: 0.0921 - acc: 0.9732 - val_loss: 0.0458 - val_acc: 0.9861
Epoch 3/12
60000/60000 [==============================] - 9s 148us/step - loss: 0.0666 - acc: 0.9802 - val_loss: 0.0323 - val_acc: 0.9889
Epoch 4/12
60000/60000 [==============================] - 9s 149us/step - loss: 0.0543 - acc: 0.9831 - val_loss: 0.0307 - val_acc: 0.9898
Epoch 5/12
60000/60000 [==============================] - 9s 145us/step - loss: 0.0475 - acc: 0.9856 - val_loss: 0.0279 - val_acc: 0.9917
Epoch 6/12
60000/60000 [==============================] - 9s 146us/step - loss: 0.0412 - acc: 0.9870 - val_loss: 0.0277 - val_acc: 0.9905
Epoch 7/12
60000/60000 [==============================] - 9s 149us/step - loss: 0.0368 - acc: 0.9884 - val_loss: 0.0265 - val_acc: 0.9910
Epoch 8/12
60000/60000 [==============================] - 9s 150us/step - loss: 0.0346 - acc: 0.9892 - val_loss: 0.0258 - val_acc: 0.9924
Epoch 9/12
60000/60000 [==============================] - 9s 150us/step - loss: 0.0324 - acc: 0.9897 - val_loss: 0.0256 - val_acc: 0.9920
Epoch 10/12
60000/60000 [==============================] - 9s 145us/step - loss: 0.0295 - acc: 0.9914 - val_loss: 0.0270 - val_acc: 0.9912
Epoch 11/12
60000/60000 [==============================] - 9s 153us/step - loss: 0.0280 - acc: 0.9912 - val_loss: 0.0281 - val_acc: 0.9913
Epoch 12/12
60000/60000 [==============================] - 9s 153us/step - loss: 0.0259 - acc: 0.9923 - val_loss: 0.0236 - val_acc: 0.9922
Test loss: 0.0235626258152497
Test accuracy: 0.9922

```
Gets to 99.22 test accuracy after 12 epochs (there is still a lot of margin for parameter tuning).
9 seconds per epoch on a AMD X470. 


Try to run keras with CPU:
```

```





















### Process of installing Nvidia graphic board driver: 
GTX-1070
GTX-1080
GTX-2080






