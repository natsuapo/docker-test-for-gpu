# A memo for building environment for different GPUs via docker

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

## find out the CPU version: 
```
cat /proc/cpuinfo 
Intel(R) Core(TM) i7-8700 CPU @ 3.20GHz
cpu cores	: 6
```

## install docker
References: 
https://qiita.com/tkyonezu/items/0f6da57eb2d823d2611d


## Build environement of AMD GPU
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
To run CPU instead of GPU, run the benchmark code with the following code: 
```
with tf.device('/cpu:0'):
```

```
x_train shape: (60000, 28, 28, 1)
60000 train samples
10000 test samples
Train on 60000 samples, validate on 10000 samples
Epoch 1/12
60000/60000 [==============================] - 62s 1ms/step - loss: 0.2626 - acc: 0.9198 - val_loss: 0.0582 - val_acc: 0.9810
Epoch 2/12
60000/60000 [==============================] - 64s 1ms/step - loss: 0.0892 - acc: 0.9730 - val_loss: 0.0433 - val_acc: 0.9865
Epoch 3/12
60000/60000 [==============================] - 66s 1ms/step - loss: 0.0686 - acc: 0.9796 - val_loss: 0.0316 - val_acc: 0.9893
Epoch 4/12
60000/60000 [==============================] - 66s 1ms/step - loss: 0.0555 - acc: 0.9833 - val_loss: 0.0361 - val_acc: 0.9881
Epoch 5/12
60000/60000 [==============================] - 61s 1ms/step - loss: 0.0467 - acc: 0.9865 - val_loss: 0.0295 - val_acc: 0.9903
Epoch 6/12
60000/60000 [==============================] - 61s 1ms/step - loss: 0.0429 - acc: 0.9870 - val_loss: 0.0293 - val_acc: 0.9901
Epoch 7/12
60000/60000 [==============================] - 61s 1ms/step - loss: 0.0369 - acc: 0.9886 - val_loss: 0.0311 - val_acc: 0.9900
Epoch 8/12
60000/60000 [==============================] - 61s 1ms/step - loss: 0.0351 - acc: 0.9890 - val_loss: 0.0267 - val_acc: 0.9921
Epoch 9/12
60000/60000 [==============================] - 63s 1ms/step - loss: 0.0322 - acc: 0.9904 - val_loss: 0.0323 - val_acc: 0.9899
Epoch 10/12
60000/60000 [==============================] - 63s 1ms/step - loss: 0.0299 - acc: 0.9910 - val_loss: 0.0257 - val_acc: 0.9917
Epoch 11/12
60000/60000 [==============================] - 65s 1ms/step - loss: 0.0266 - acc: 0.9915 - val_loss: 0.0267 - val_acc: 0.9920
Epoch 12/12
60000/60000 [==============================] - 66s 1ms/step - loss: 0.0253 - acc: 0.9923 - val_loss: 0.0355 - val_acc: 0.9899
Test loss: 0.035532569728241745
Test accuracy: 0.9899

```
Here one ephco cost 66s. 


## Build environment of Nvidia GPU:
### Process of installing Nvidia graphic board driver: 
follow the url: https://qiita.com/spiderx_jp/items/460cd47ce0e0ff41c762  

For installing driver, use autoinstaller might be eaiser: 
```
sudo ubuntu -drivers autoinstall
```

result of GTX-1070: 
```
user@user-desktop:~$ nvidia-smi
Wed Oct 31 13:28:59 2018       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 384.130                Driver Version: 384.130                   |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 1070    Off  | 00000000:01:00.0  On |                  N/A |
|  0%   37C    P8    11W / 151W |    194MiB /  8105MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|    0      1640      G   /usr/lib/xorg/Xorg                            81MiB |
|    0      2365      G   /usr/bin/gnome-shell                         107MiB |
|    0      3470      G   /usr/lib/firefox/firefox                       3MiB |
+-----------------------------------------------------------------------------+
```
### Install nvidia-docker2:  
Follow the tutorial: https://qiita.com/spiderx_jp/items/32c421fd00c6ade19720

### Prepare the Dockerfile for installing anaconda, jupyter, tensorflow, keras:
- Follow the tutorial: https://qiita.com/tomo_makes/items/0bb10bcaf7093855e9e5
- For dockerfile build: http://www.atmarkit.co.jp/ait/articles/1407/08/news031.html  
- The docker file is available in https://github.com/natsuapo/docker-test-for-gpu/blob/master/Dockerfile

### Build iamge from docker file and run the image: (make sure that dockerfile is in the current directory)
```
sudo docker build -t test/my-dl-image .
sudo nvidia-docker run --rm -p 8888:8888 -t test/my-dl-image
```
### Run jupyter notebook in docker and test the mnist benchmark again: 
```
jupyter notebook --ip=0.0.0.0 --allow-root

x_train shape: (60000, 28, 28, 1)
60000 train samples
10000 test samples
Train on 60000 samples, validate on 10000 samples
Epoch 1/12
60000/60000 [==============================] - 11s 184us/step - loss: 0.2808 - acc: 0.9140 - val_loss: 0.0607 - val_acc: 0.9802
Epoch 2/12
60000/60000 [==============================] - 5s 87us/step - loss: 0.0919 - acc: 0.9722 - val_loss: 0.0426 - val_acc: 0.9847
Epoch 3/12
60000/60000 [==============================] - 5s 89us/step - loss: 0.0667 - acc: 0.9797 - val_loss: 0.0364 - val_acc: 0.9875
Epoch 4/12
60000/60000 [==============================] - 5s 86us/step - loss: 0.0549 - acc: 0.9834 - val_loss: 0.0297 - val_acc: 0.9899
Epoch 5/12
60000/60000 [==============================] - 5s 75us/step - loss: 0.0469 - acc: 0.9858 - val_loss: 0.0281 - val_acc: 0.9906
Epoch 6/12
60000/60000 [==============================] - 5s 86us/step - loss: 0.0420 - acc: 0.9872 - val_loss: 0.0313 - val_acc: 0.9887
Epoch 7/12
60000/60000 [==============================] - 5s 87us/step - loss: 0.0386 - acc: 0.9885 - val_loss: 0.0296 - val_acc: 0.9903
Epoch 8/12
60000/60000 [==============================] - 5s 84us/step - loss: 0.0347 - acc: 0.9895 - val_loss: 0.0263 - val_acc: 0.9919
Epoch 9/12
60000/60000 [==============================] - 5s 86us/step - loss: 0.0325 - acc: 0.9899 - val_loss: 0.0274 - val_acc: 0.9910
Epoch 10/12
60000/60000 [==============================] - 5s 79us/step - loss: 0.0290 - acc: 0.9910 - val_loss: 0.0304 - val_acc: 0.9904
Epoch 11/12
60000/60000 [==============================] - 5s 80us/step - loss: 0.0285 - acc: 0.9912 - val_loss: 0.0273 - val_acc: 0.9916
Epoch 12/12
60000/60000 [==============================] - 5s 86us/step - loss: 0.0277 - acc: 0.9917 - val_loss: 0.0293 - val_acc: 0.9910
Test loss: 0.0293040658824
Test accuracy: 0.991

```
Here one epoch is 5s.


## Stopping container
For stopping container, please refer to https://qiita.com/tifa2chan/items/e9aa408244687a63a0ae







