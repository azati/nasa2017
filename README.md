# nasa2017

## roofs classifying

Install [docker](https://docs.docker.com/engine/installation/linux/ubuntu/#install-docker) and [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)

Clone the repository:
```sh
git clone https://github.com/azati/nasa2017
```

Build docker image:
```sh
cd nasa2017/backend/docker_image
docker build -t theano_gpu .
```

Unpack roofs images:
```sh
cd ../roofs_classifying/data
unrar x -r all_buildings.part1.rar
```

Download pre-trained weights for *ResNet-50*:
```sh
cd ..
wget https://s3.amazonaws.com/lasagne/recipes/pretrained/imagenet/resnet50.pkl
```

Run jupyter:
```sh
./run_jupyter.sh
```

Navigate http://localhost:8888 and open file all_buildings_prediction-resnet.ipynb

Run all the cells in the notebook to perform roofs classification.

## ios app

Install [CocoaPods](http://cocoapods.org)

Run `pod install` from Terminal, then open your app's `.xcworkspace` file to launch Xcode.

Team https://azati.com 
