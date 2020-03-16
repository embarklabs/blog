title: Smart Contract security analysis with MythX
summary: "Analyse Smart Contract security throughout the development lifecycle using the Embark MythX plugin."
author: graham_mcbain
categories:
  - smart contracts
  - security
  - mythx
  - tutorial
layout: blog-post
image: '/assets/images/mythx_dashboard.png'
---

![Embark dashboard with MythX](/assets/images/mythx_dashboard.png)

## How MythX works
[MythX](https://mythx.io/) scans for security vulnerabilities in Ethereum and other EVM-based blockchain smart contracts. MythX's comprehensive range of analysis techniques — including static analysis, dynamic analysis, and symbolic execution — can accurately detect security vulnerabilities to provide an in-depth analysis report. These security analyses can be used throughout the development lifecycle to aid in preparation for a security audit. Using MythX during development eases the impact of a security audit and helps to build secure Smart Contracts from the ground up. The idea is that once MythX returns no technical errors, the contracts are ready for a full audit.

MythX detects the majority of vulnerabilities listed in the [SWC Registry](https://mythx.io/swc-coverage). The report will return a listing of all the weaknesses found in the code, including the exact position of the issue and its SWC ID. Analysis reports generated can be only accessed by the owner of the account (you).

Contracts are submitted to MythX using their [API](https://api.mythx.io/v1/openapi#operation/submitAnalysis). A full list of all completed analysis reports can be seen in the [MythX dashboard](https://dashboard.mythx.io/#/console/analyses).

![MythX dashboard with analyses](/assets/images/mythx_dashboard-analyses.png)

MythX was designed to work with third party security tools and developer plugins. This has paved the way to allow MythX integration in to Embark, by way of the [Embark MythX plugin](https://github.com/flex-dapps/embark-mythx). The Embark MythX plugin allows developers to easily submit their contracts (all contracts, or just those that need it) for analysis and see the resulting report in the console.

Let's walk through this and see how it can be done!

1. [Prerequisites](#Step-1-Prerequisites)
2. [Create a &ETH;App](#Step-2-Create-a-ETH-App)
3. [Install the Embark MythX plugin](#Step-3-Install-the-Embark-MythX-plugin)
4. [Create a `.env` file with MythX credentials](#Step-4-Create-a-env-file-with-MythX-credentials)
5. [Run Embark](#Step-5-Run-Embark)
6. [Run some MythX commands](#Step-6-Run-some-MythX-commands)
7. [Conclusion](#Conclusion)

## Step 1. Prerequisites
Before we can submit our first contract for analysis, let's take care of a few requirements.

### Install Embark
[Install Embark](https://framework.embarklabs.io/docs/installation.html) either globally or as a package in your &ETH;App. The most simple way forward is to install Embark globally on your system:
```
yarn global add embark
# OR
npm i -g embark
```

The rest of this article will assume you have Embark installed globally, and therefore available from the CLI.

### Create a MythX account
You'll need to [create a MythX account](https://docs.mythx.io/en/latest/getting-started/index.html) before any contracts can be submitted. The dashboard of this account will list all completed analyses. Signing up for a free plan is easy. The free plan is a great way to test out MythX's features without forking over any dollary-doos. You may skip the step of connecting your Ethereum address with MetaMask if you'd like, as a username and password are sufficient to proceed with this tutorial.

## Step 2. Create a &ETH;App
For this article, we will be creating a demo &ETH;App to use as a base for submitting our first contract for analysis. However, if you already have a &ETH;App with contracdts that you'd like to use instead, simply skip this step.

Creating an Embark demo is easy, simply run the following commands:
```
embark demo
cd embark_demo
```
This will create a &ETH;App with one contract, SimpleStorage, which we will submit to MythX for analysis.

## Step 3. Install the Embark MythX plugin
Installing the [Embark MythX](https://github.com/flex-dapps/embark-mythx) plugin in our &ETH;App is extremely simple:
1. Add the `embark-mythx` package to your &ETH;App:
```
yarn add embark-mythx
# OR
npm i embark-mythx --save
```
2. Add the `embark-mythx` plugin to `embark.json`:
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
  "embark-mythx": {} // <====== add this!
},
// ...
```

## Step 4. Create a `.env` file with MythX credentials
Create a `.env` file in the root of your &ETH;App. Add your MythX username and password like so:
```
MYTHX_USERNAME="satoshi.nakamoto@gmail.com"
MYTHX_PASSWORD="abc123"
```

## Step 5. Run Embark
Now that we have installed the plugin, let's run Embark to get access to its dashboard:
```
embark run --nobrowser
```
Once Embark has completed bootstrapping, we should see a command prompt in the Embark dashboard at the bottom:
![MythX dashboard with analyses](/assets/images/mythx_embark-dashboard-console.png)

## Step 6. Run some MythX commands

All functionality for the Embark MythX plugin can be accessed via the `verify` command.

### Available commands
For a full list of available options and usage instructions, execute the `help` command in the console:
```
Embark (development) > verify help
```
We can see there are a few options for us to use and we can also see how they can be used:
```
Usage:
        verify [--full] [--debug] [--limit] [--initial-delay] [<contracts>]
        verify status <uuid>
        verify help

Options:
        --full, -f                      Perform full rather than quick analysis.
        --debug, -d                     Additional debug output.
        --limit, -l                     Maximum number of concurrent analyses.
        --initial-delay, -i             Time in seconds before first analysis status check.

        [<contracts>]                   List of contracts to submit for analysis (default: all).
        status <uuid>                   Retrieve analysis status for given MythX UUID.
        help                            This help.
```

### Verify the SimpleStorage contract
Let's take a peek to see how easy it is to analyse our SimpleStorage contract.

In the Embark console, execute the following command to submit our SimpleStorage contract for MythX security analysis:
```
verify
```
The results should look the following:
![SimpleStorage security analysis](/assets/images/mythx_simplestorage-analysis.png)

We can see from the security analysis output in the console that there is an error marked "SWC-103". Looking at the [SWC Registry for SWC-103](https://swcregistry.io/docs/SWC-103) help, we can remedy this by changing line 1 of our `contracts/simple_storage.sol` to:
```
pragma solidity 0.6.1;
```
Embark will detect the change in the contract and automatically recompile and redeploy our contract. We can then re-submit our contract for analysis:
```
verify
```
And voila! 
```
Running MythX analysis in background.
Submitting 'SimpleStorage' for quick analysis...

MythX analysis found no vulnerabilities.
```
MythX has confirmed that we no longer have any security issues!

### Viewing the submissions in the MythX dashboard
Open your browser and go to the [MythX analyses](https://dashboard.mythx.io/#/console/analyses) page. After logging in, you should be able to see a list of all the contracts you've submitted for analyses. 

![Mythx Analysis List](/assets/images/mythx_dashboard_showing_submissions.png)

Click in to each job and then in to each contract, and you will should see details of the security analysis, along with line numbers in the source and a preview of issues in the code at the bottom of the page.

![Mythx Analysis Detail](/assets/images/mythx_analysis-detail.png)

## Conclusion
We have seen firsthand how the Embark MythX plugin can assist in our development workflow, allowing us to analyse the security of our contracts throughout the development lifecycle. While we have only scraped the surface as to the complexity of the MythX's security analysis, the [Status Embark + MythX](https://medium.com/flex-dapps/status-embark-mythx-4786cd989d75) article dives in to more detail on common contract vulnerabilities and how they are presented using the Embark MythX plugin.