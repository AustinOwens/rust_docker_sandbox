# Rust Sandbox
A sandbox for learning Rust.

This repo creates a docker image that can be used for playing around with the Rust programming language and Rust build tools.

## Building and running docker image
```shell
cd rust_sandbox
./start.sh -b rust_sandbox_img rust
```

## Compiling and running sample Rust application inside container
```shell
cd random_num_guesser_app
cargo run
```

## Host/container file sharing
The host can share files to the container (or vice versa) through the "shared" directory. Inside the container, this will be /mnt/shared. When the container launches, it will symbolically link all directories in /mnt/shared to the /root directory for convenience. 

## Stateless container
This is by default a stateless container, meaning the container does not need to retain its state to operate properly. Stateless containers are generally considered good practice because this means there are less dependencies for the container to work (you can just spin-up a container from the image instead of needing to keep a container around). As a result, the container is destroyed once you exit from its shell. Make sure any work you want to save is in /mnt/shared inside the container before you exit.

## Restarting container
Just run the same command as above:

```shell
./start.sh -b rust_sandbox_img rust
```

to spin-up a new container. Anything you put under /mnt/shared from before will also be in the container.

## Useful resources for learning Rust
* https://doc.rust-lang.org/book/ch00-00-introduction.html
* https://docs.rust-embedded.org/book/intro/index.html
* https://doc.rust-lang.org/std/index.html
* https://doc.rust-lang.org/rust-by-example/index.html
* https://github.com/rust-lang/rustlings
* https://play.rust-lang.org/


