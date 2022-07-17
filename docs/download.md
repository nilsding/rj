---
---

# Get it

rq is written in C++ and has no runtime dependencies[^1].  Building it should
Just Work™ for most platforms, as long as there is a working C++17 compiler
for it and it's supported by [mruby].

## Binaries

As rq is still a work in progress there are no binaries for rq released yet.

From the time being you will need to build it yourself from source.

## Build from source

You can download the sources here:

- Current version: **{{ site.data.current_version }}**
  ([.tar.gz][currver_tgz], [.zip][currver_zip])
- Development version ([.tar.gz][main_tgz], [.zip][main_zip],
  [git repository][main_git])

To build rq you first need to install the following build-time requirements:

- CMake 3.20 (or newer)
- Ruby 2.5 (or newer)
- a C++17 compiler (clang++ or g++ are fine)
- git

Once all build-time dependencies are installed you can go ahead and build it.
The building process should be a matter of:

```sh
mkdir -p build && cd build
cmake ..
make
```

During the `make` step mruby is downloaded and built, there are no extra steps
needed for that.

If you want to install rq on your system you can run `sudo make install`
afterwards.

### macOS

You can install CMake and Git from [Homebrew][brew].  The C++17 compiler
bundled with XCode (clang++) works fine; and macOS Monterey (12.4) ships with
Ruby 2.6.8 which should be fine too (though I use a newer Ruby version using
[rbenv]).

```sh
brew install cmake git
```

### Linux

#### openSUSE

All dependencies are installable from the default repos via `zypper`:

```sh
sudo zypper in cmake gcc-c++ ruby git
```

[^1]:
    excluding basic libraries that should already be present on your systems,
    such as `libc++`/`libstdc++`, `libm`, `libc`.

[mruby]: https://mruby.org/
[currver_tgz]: https://github.com/nilsding/rq/archive/refs/tags/{{ site.data.current_version }}.tar.gz
[currver_zip]: https://github.com/nilsding/rq/archive/refs/tags/{{ site.data.current_version }}.zip
[main_tgz]: https://github.com/nilsding/rq/archive/refs/heads/main.tar.gz
[main_zip]: https://github.com/nilsding/rq/archive/refs/heads/main.zip
[main_git]: https://github.com/nilsding/rq.git
[brew]: https://brew.sh/
[rbenv]: https://github.com/rbenv/rbenv
