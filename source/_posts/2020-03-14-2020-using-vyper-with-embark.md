title: Using Vyper with Embark
summary: "Vyper has gained some traction on Solidity as an Ethereum smart contract language, especially with support going in to ETH2. Learn how to use Embark to use Vyper smart contracts in a &ETH;App."
author: eric_mastro
categories:
  - Report
layout: blog-post
image: '/assets/images/vyper_simple_storage_with_logo.png'
---

![Vyper Language](/assets/images/vyper_simple_storage_with_logo.png)

## Why Vyper?
[Vyper](https://github.com/vyperlang/vyper) is a contract-based approach to writing Ethereum smart contracts and is aimed at bringing ["increased security and readability through a minimalist approach"](https://ethereumdevelop.com/ethereum-solidity-vyper/) to the smart contract landscape.

Although Vyper has gained some popularity in recent times as a security-focused alternative to Solidity, the simplicity required for such a case [leaves out some features of Solidity](https://ethereumdevelop.com/ethereum-solidity-vyper/) that developers have come to appreciate.

In its current form, Vyper is python-based, but due to the [Consensys audit highlighting some major security flaws](https://diligence.consensys.net/audits/2019/10/vyper/), the Ethereum Foundation has decided to concurrently build a [Rust-based Vyper](https://github.com/ethereum/rust-vyper), while community devs aim to support the original Python-based version.

{% notification danger 'Using Vyper in production' %}
Because of the inherent security flaws, please **do not** use Python-based Vyper in production projects until the [vyperlang team](https://github.com/vyperlang/vyper) has created a production-ready release. Embark will also support Rust-based Vyper once it is released.
{% endnotification %}

Irrespective of the security audit, Vyper is perhaps the [most intuitive and easiest to quickly learn language](https://www.publish0x.com/rhyzom/vyper-compiler-security-audit-and-developing-a-new-rust-base-xxpygm) for reading and writing Etheruem contracts - even without any prior knowledge or experience in programming. Additionally, Embark has created a plugin that makes it just as easy to compile Vyper contracts in an Embark &ETH;App!

Let's see just how easy this is!

1. [Prerequisites](#Step-1-Prerequisites)
2. [Create a &ETH;App](#Step-2-Create-a-ETH-App)
3. [Install the Embark Vyper plugin](#Step-3-Install-the-Embark-Vyper-plugin)
4. [Add a Vyper contract to your &ETH;App](#Step-4-Add-a-Vyper-contract-to-your-ETH-App)
5. [Run Embark](#Step-5-Run-Embark)
6. [Interact with your contract in Cockpit](#Step-6-Interact-with-your-contract-in-Cockpit)

## Step 1. Prerequisites
Before we can write our first Vyper contract, let's take care of a few requirements.

### Install Embark
[Install Embark](https://framework.embarklabs.io/docs/installation.html) either globally or as a package in your &ETH;App. The most simple way forward is to install Embark globally on your system:
```
yarn global add embark
# OR
npm i -g embark
```

The rest of this article will assume you have Embark installed globally, and therefore available from the CLI.

### Install Vyper
If you haven't already done so, make sure to [install Vyper](https://vyper.readthedocs.io/en/latest/installing-vyper.html). As the documentation recommends, be sure to [use a Python virtual environment when installing Vyper](https://vyper.readthedocs.io/en/latest/installing-vyper.html#creating-a-virtual-environment), as it will keep your system-wide packages from being polluted.

## Step 2. Create a &ETH;App
For this article, we will be creating a demo &ETH;App to use as a base for creating our first Vyper contract. However, if you already have a &ETH;App that you'd like to add Vyper contracts to, simply skip this step.

Creating an Embark demo is easy, simply run the following commands:
```
embark demo
cd embark_demo
```

## Step 3. Install the Embark Vyper plugin
Installing the [Embark Vyper](https://github.com/embarklabs/embark/blob/master/packages/plugins/vyper/README.md) plugin in our &ETH;App is extremely simple:
1. Add the `embark-vyper` package to your &ETH;App:
```
yarn add embark-vyper
# OR
npm i embark-vyper --save
```
2. Add the `embark-vyper` plugin to `embark.json`:
```
// embark.json

// ...
"plugins": {
  "embark-ipfs": {},
  "embark-swarm": {},
  "embark-whisper-geth": {},
  "embark-geth": {},
  "embark-parity": {},
  "embark-profiler": {},
  "embark-graph": {},
  "embark-vyper": {} // <====== add this!
},
// ...
```

## Step 4. Add a Vyper contract to your &ETH;App
First, let's delete the `SimpleStorage` Solidity contract that comes with the Embark Demo by default:
```
rm contracts/simple_storage.sol
```
Next, let's create a Vyper contract in the `contracts` folder of our &ETH;App, ie `contract/SimpleStorage.vy` (case is important):
```
# contracts/SimpleStorage.vy

storedData: public(int128)

@public
def __init__(_x: int128):
  self.storedData = _x

@public
def set(_x: int128):
  self.storedData = _x
```
The function of this contract is simple: upon creation (deployment), it will store the value we initially give it during deployment. We also have access to a `set()` that will allow to set the value stored in the contract.

### Changing the contract filename
Because Vyper's constructor is called `__init__`, Embark must take the contract class name from the file name. If you'd prefer to change the name of your contract file to something else like `contracts/simple_storage.vy`, you'll need to update `config/contract.js` to allow Embark to match a contract configuration to a contract file:
```
// config/contracts.js

module.exports = {
  default: {
    // ...
    deploy: {
      simple_storage: { // NOTE: this only needs to be changed if the contract filename was changed
        fromIndex: 0,
        args: [100]
      }
    }
    // ...
  }
}
```
Please see the Embark [smart contract configuration documentation](https://framework.embarklabs.io/docs/contracts_configuration.html) for more information on how to configure contracts in Embark.

## Step 5. Run Embark
Now that we have installed and configured everything, let's run Embark and watch the magic!
```
embark run --nodashboard --nobrowser
```
Assuming we kept the file name `SimpleStorage.vy` from step 4, we should see the following output in the console:
```
compiling Vyper contracts...
deploying contracts
Deploying SimpleStorage with 144379 gas at the price of 2000000000 Wei. Estimated cost: 288758000000000 Wei  (txHash: 0x370a864b12b1785b17180b2a10ec2f941a15638eeffadfecf5bbe68755a06f14)
SimpleStorage deployed at 0x5Baf4D88bC454537C51CEC7568a1E23400483abc using 135456 gas (txHash: 0x370a864b12b1785b17180b2a10ec2f941a15638eeffadfecf5bbe68755a06f14)
```

### Troubleshooting
There are a few common issues you may experience when Embark attempts to compile and deploy your Vyper contracts.

#### Vyper is not installed on your machine
```
Vyper is not installed on your machine
You can install it by visiting: https://vyper.readthedocs.io/en/latest/installing-vyper.html
```
This means that the binary `vyper` cannot be found on your machine. If you're running *nix, you can verify this by running:
```
which vyper
# expected output: path/to/virtual-env/bin/vyper
# actual output: vyper not found
```
If `vyper` was [installed in a virtual environment](https://vyper.readthedocs.io/en/latest/installing-vyper.html#creating-a-virtual-environment), you may have forgotten to activate the environment, ie:
```
source path/to/vyper-env/bin/activate
```
If `vyper` was not installed in a virual environment, it most likely means your `PATH` environment variable needs to be updated to point to the directory where the `vyper` binary is installed. You can inspect your `PATH` environment variable by:
```
echo $PATH
```
And update it with the path to *the directory containing* the `vyper` binary using:
```
export PATH=/path/to/vyper/dir:$PATH
```

#### Error deploying contract
```
SimpleStorage has no code associated
did you mean "simple_storage"?
deploying contracts
Error deploying contract simple_storage
[simple_storage]: Invalid number of parameters for "constructor". Got 0 expected 1!
Error deploying contracts. Please fix errors to continue.
```
This means that the contract `simple_storage` is a file in `contracts/` and expected to be deployed by Embark, but is not configured for deploy in the contracts configuration. This could be the result of changing the filename of the Vyper contract to `simple_storage.vy`, but not updating the contracts configuration, as outlined in [step 4](#Changing-the-contract-filename).

## Step 6. Interact with your contract in Cockpit
Given that the Vyper contract has the same functionality as the `SimpleStorage.sol` that ships with the default Embark demo, we could still run the Demo application and view that its functionality works as expected. However, an even easier approach to interacting with our deployed Vyper contract is to use Cockpit.

In your browser, open Cockpit using the link provided in the console, ie `http://localhost:55555?token=<token from console>` NOTE: the `token` parameter is provided in the Embark console once Embark has finished building pipeline files. This token can be copied to the clipboard by typing `token` in the console command prompt.

![Cockpit with Vyper contract](/assets/images/vyper_Cockpit-with-Vyper-contract.png)

At the bottom, you should see your `SimpleStorage` contract. Click the name of the contract to open the interaction view:

![SimpleStorage vyper contract in Cockpit](/assets/images/vyper_SimpleStorage-Vyper-contract-in-Cockpit.png)

Expand the `set` method interaction by clicking the `set` header. Enter a value to set the `storedData` variable in the contract to, ie `999`:

![SimpleStorage set value to 999](/assets/images/vyper_SimpleStorage-set-value-to-999.png)

Then click "Send". You should see the inputs and the resulting transaction hash:

![SimpleStorage set result](/assets/images/vyper_SimpleStorage-set-result.png)

Additionally, you should see the transaction printed in Embark's console:
```
Blockchain> SimpleStorage.set(999) | 0x71a9341fc8d52e53e11692b642b806a41da7aa8ed2b3ed6a975314639a131d32 | gas:26447 | blk:14 | status:0x1
```

## Conclusion
Vyper is proving to be a useful language for writing secure smart contracts. While the latest security audit is looming, the EF is working on a Rust-based implementation that will hopefully propel Vyper towards its goals of being a security-centric, simplistic smart contract language.

In the meantime, we can use Embark to write and deploy our Vyper contracts using the [Embark Vyper](https://github.com/embarklabs/embark/blob/master/packages/plugins/vyper/README.md) plugin.
