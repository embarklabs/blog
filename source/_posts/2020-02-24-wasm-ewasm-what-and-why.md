title: WebAssembly / eWasm – What, and Why?
summary: "Apparently; WebAssembly became 'the fourth language for the web' a couple of years ago.. Find out what that means for the Decentralised Web (DApps & eWasm) in this article."
author: robin_percy
categories:
  - tutorials
layout: blog-post
image: '/assets/images/eWASM-header.png'
---

![eWasm](/assets/images/eWASM-header.png)


> *This article is the third in my series of articles based on the frontend of the decentralised web.  Throughout the series we'll look at [Web3.js](/news/2019/12/09/web3-what-are-your-options/) & accessing the Ethereum Blockchain client-side, [frontend security for DApps](/news/2020/01/30/dapp-frontend-security/), how [eWasm / WebAssembly](/news/2020/02/18/wasm-eWasm-what-and-why/) has become the "4th language of the web", and we'll build a realtime Blockchain explorer app with Phoenix LiveView!*

## Introduction

As I mentioned in the foreword of this article series; I read recently that WebAssembly (*Wasm*) has become the *4th language for the decentralised web*, and as I took time to really consider that notion, I came up with some points both for, and against it.

WebAssembly is a way of taking code written in programming languages other than JavaScript and running that code in the browser.

Basically; Wasm can be summarised as an ***efficient*** binary format.  This binary format serves as a compilation target, which can be compiled to **execute at native speed**, by taking advantage of common hardware capabilities available over a range of platforms – including mobile and IoT.

Today, I'd like to show you what I've discovered about *Wasm*, and in keeping with my  **decentralised web frontend** series; in particular – [**eWasm** (Web Assembly for Ethereum)](https://eWasm.readthedocs.io/en/mkdocs/).

> ***'Ethereum flavoured WebAssembly is a proposed redesign of the Ethereum Smart Contract execution layer using a deterministic subset of WebAssembly.'***



## Firstly; Wasm Goals

The original design goals of WebAssembly are the following:

 - Fast: executes with near native code performance, taking advantage of capabilities common to all contemporary hardware.
 - Safe: code is validated and executes in a memory-safe, sandboxed environment preventing data corruption or security breaches.
 - Well-defined: fully and precisely defines valid programs and their behaviour in a way that is easy to reason about informally and formally.
 - Hardware-independent: can be compiled on all modern architectures, desktop or mobile devices and embedded systems alike.
 - Language-independent: does not privilege any particular language, programming model, or object model.
 - Platform-independent: can be embedded in browsers, run as a stand-alone VM, or integrated in other environments.
 - Open: programs can interoperate with their environment in a simple and universal manner.

As far as I can see, Wasm has indeed achieved the above goals.



## How Wasm Works

WebAssembly delivers significant performance gains because modern browser engines can parse and execute its binary format an order of magnitude faster than vanilla JavaScript itself.  So; you can take C/C++ code, translate it into Wasm using a compiler tool, and load the generated Wasm module into a JavaScript app, where it will be executed by the browser.

![wasm editor](/assets/images/wasm_explorer_online_app.png)

From what I've read, I believe one of the biggest ideas behind Wasm; is to make it possible to run media-rich game engines, and support such graphics-heavy games in-browser, without the use of plug-ins. It also has non-web applications such as the Internet of Things, mobile apps and JavaScript virtual machines.

<iframe width="100%" height="300" src="https://www.youtube.com/embed/MaJCfdmr9Wg" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

If you want to get started with Wasm, you can download a precompiled toolchain to compile C/C++ to WebAssembly by running the following:

```bash
$ git clone https://github.com/emscripten-core/emsdk.git
$ cd emsdk
$ ./emsdk install latest
$ ./emsdk activate latest
```


## Wasm to eWasm (Ethereum flavoured WebAssembly)

Great! &nbsp; Now that we have Wasm introduced, explained, and out-of-the-way, we can move onto the (arguably) more important topic – ***eWasm***!  So.. what exactly is eWasm?

Simply put; eWasm is a restricted subset of Wasm to be used for Smart Contracts in Ethereum.  Much like Wasm, one of the biggest goals of eWasm is to be fast & efficient.  To truly distinguish Ethereum as the *"World Computer",* we need to have a super performant VM. The current architecture of the VM is one of the greatest blockers to raw performance.  

As I mentioned in the Wasm section above; WebAssembly aims to execute at near native speed by taking advantage of common hardware capabilities available on a wide range of platforms. This will open the door for Ethereum to a wide array of uses that require performance/throughput.

Security is another key goal.  With the added performance gains from eWasm we will be able to implement parts of Ethereum such as the precompiled Smart Contract in the VM itself which will minimise our trusted computing base.  WebAssembly is currently being designed as an open standard by a W3C Community Group and is actively being developed by engineers from Mozilla, Google, Microsoft, and Apple.



## eWasm Goals

Goals of the eWasm project:

 - To provide a specification of eWasm Smart Contract semantics and the Ethereum interface.
 - To provide an EVM transcompiler, preferably as an eWasm Smart Contract.
 - To provide a VM implementation for executing eWasm Smart Contracts.
 - To implement an eWasm backend in the Solidity compiler.
 - To provide a library and instructions for writing Smart Contracts in Rust.
 - To provide a library and instructions for writing Smart Contracts in C.
 - To provide a *metering injector**, preferably as an eWasm Smart Contract.

**Metering injector* is a transformation tool inserting metering code to an eWasm Smart Contract.

**Toolchain Compatibility:** A LLVM front-end for Wasm is part of the MVP. This will allow developers to write Smart Contracts and reuse applications written in common languages such as C/C++, go and rust.

**Portability**: Wasm is targeted to be deployed in all the major web browsers which will result in it being one of the most widely deployed VM architecture. Smart Contracts compiled to eWasm will share compatibility with any standard Wasm environment. Which will make running a program either directly on Ethereum, on a cloud hosting environment, or on one's local machine - a frictionless process.

**Optional And Flexible Metering:** Metering the VM adds overhead but is essential for running untrusted code. If code is trusted, then metering maybe optional. eWasm defines metering as an optional layer to accommodate for these usecases.


## eWasm Performance

This chart shows the Wasm-based EVM setting new performance records in a typical   sha1 benchmark experiment.  It is shown here against *Evmone* (a C++ implementation) and *Cita-vm* (a rust implementation).

![Wasm EVM benchmarking](/assets/images/wasm-evm-benchmarks.png)  

I took this benchmark directly from the eWasm GitHub, I didn't run the tests myself. You can find the full details, alongside more benchmark testing [here.](https://github.com/eWasm/benchmarking#sha1)


## eWasm and Embark

With Status / Embark being at the forefront of Decentralised technology; naturally we are very on-board with eWasm and the improvements it brings to the EVM.

Check out two of our extremely talented engineers; [Pascal](https://twitter.com/PascalPrecht) and [Eric](https://twitter.com/ericmastro) giving a talk on eWasm at Devcon 5:

<iframe width="100%" height="315" src="https://www.youtube-nocookie.com/embed/t2LgFXxcFtc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>



## Conclusion

Since its launch a couple of years ago; *Wasm* has grown from an impressive concept into an even-more-impressive piece of technology.  Alongside which a flourishing community has grown.  

Although, personally, I have my reservations in agreeing with the statement that *Wasm* is the "most significant new technology to come to the web platform in a decade"...   It definitely **is** impressive, and I can certainly see how & why it has made a good impact, and does have a lot of devs working on relative tooling and implementations.  This was an interesting (albeit old) article I just stumbled across this morning:  [Life: A secure, blazing-fast, cross-platform WebAssembly VM in Go.](https://medium.com/perlin-network/life-a-secure-blazing-fast-cross-platform-webassembly-vm-in-go-ea3b31fa6e09)

Between Wasm & eWasm, I'm excited to see the performance boosts we can achieve as they grow, and as our own DApp development grows.  I'd love to find an excuse to build out a big piece of technology with eWasm, but this *would* be a big project that I just don't have time for right now!

Thanks again for reading my series on DApp frontend.  The next (and unfortunately) final article in the series will be released next week, and is sure to be a **real humdinger!**  We'll be building a realtime crypto/blockchain tracker app using Elixir & [Phoenix's](https://www.phoenixframework.org/) newly popular [LiveView!](https://github.com/phoenixframework/phoenix_live_view)


[ **- @rbin**](https://twitter.com/rbin)
