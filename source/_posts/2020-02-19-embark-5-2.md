title: Embark 5.2
author: iuri_matias
summary: "Embark 5.2 release"
categories:
  - announcements
  - releases
  - embark
layout: blog-post
image: '/assets/images/embark-header_blank.jpg'
---

![Embark Labs](/assets/images/embark_logo.png)

Embark 5.2
===

In this release of Embark we introduce some new features such as [proxy contract support](#Proxy-Contract-Support) and [scripts execution](#Scripts-Runner). We're also introducing some important [deprecation warnings](#Transition-to-Embark-6-0) in preparation for Embark 6.0. We are making Embark lighter and more modular and to that end some modules that come by default will become optional plugins instead.

## Proxy Contract Support

Proxy contracts are powerful tools usually used in more complex Dapps. They can be used for smart contracts that can be upgraded or to alleviate the deploy cost of multiple instances of a contract.

However, interacting with Proxy contracts is usually difficult, because you have to point the base contract to the address of the Proxy for it to work.

Not anymore! Embark now supports a contract configuration named `proxyFor`.

With it, you can specify that a Proxy contract is, well, a proxy *for* another one. Here's an example:

```javascript
deploy: {
  Proxy: {
    deploy: false
  },
  BaseContract: {
    args: ["whatever the base contract needs"]
  },
  ContractInstance: {
    instanceOf: "Proxy",
    proxyFor: "BaseContract",
    args: ["0x", "$BaseContract"]
  }
}
```

With this configuration, our `ContractInstance` is an `instanceOf` `Proxy` and  a `proxyFor` `BaseContract`.
This is why we point to `BaseContract` in the `ContractInstance` arguments.
The arguments themselves depend on the implementations of your `BaseContract` and `Proxy` contract.

Note that you could have used `Proxy` itself as a `proxyFor` `BaseContract`, but it's usually more intuitive to use `instanceOf` and then resolve the contract instance with the new name you gave it (`ContractInstance` in this case).

Once the smart contracts are deployed, all you have to do is:

```
import ContractInstance from 'path/to/artifacts/contracts/ContractInstance';
```

For more information check the documentation for [Proxy Contract Support](https://framework.embarklabs.io/docs/contracts_configuration.html#Proxy-Contract-Support)

## Scripts Runner

Embark uses a powerful [declarative configuration](/docs/contracts_configuration.html) of smart contracts. The parameters of smart contracts, how they relate to each other, what [actions](/docs/contracts_configuration.html#Deployment-hooks) to do when they are deployed are described in a declarative configuration file and Embark then takes care of deploying the smart contracts in a way that reflects the configuration described.

Although this system covers the vast majority of cases, there are some situations where having the ability to execute scripts separately is useful, to that end Embark 5.2 now includes support for scripts, this can be used as migrations or as isolated scripts.

A script is really just a file with an exported function that has special dependencies injected into it. Here's what it could look like:

```
modules.exports = async ({ contracts, web3, logger}) => {
  ...
};
```

The injected parameters are:

- `contracts` - A map object containing all of your Smart Contracts as Embark Smart Contract instances.
- `web3` - A web3 instances to give you access to things like accounts.
- `logger` - Embark's custom logger.

Scripts can be located anywhere on your machine, but should most likely live inside your project's file tree in a dedicated folder.

To run a script, use the CLI `exec` command and specify an environment as well as the script to be executed:

```
$ embark exec development scripts/001.js
```

The command above will execute the function in `scripts/001.js` and ensures that Smart Contracts are deployed in the `development` environment.

If you have multiple scripts that should run in order, it's also possible to specify the directory in which they live in:

```
$ embark exec development scripts
```

Embark will then find all script files inside the specified directory (in this case `scripts`) and then run them one by one. If any of the scripts fails by emitting an error, Embark will abort the execution. Scripts are executed in sequence, which means all following scripts won't be executed in case of an error.

**Tracking scripts**

Just like Smart Contract deployments are tracked, (migration) scripts can be tracked as well. Since scripts can be one-off operations, Embark will not track whether they have been executed by default. Users are always able to run a script using the `exec` command as discussed in the previous sections.

To have Embark "remember" that a certain script was already run, you can use the `--track` option of the `exec` command, which will force tracking for this particular script:

```
$ embark exec development scripts/001.js --track
```

If we try to run the script again with the `--track` option, Embark will notice that the script has already been executed and tell us that it's "already done".

```
$ embark exec development scripts/001.js --track
.. 001.js already done
```

If however, we don't provide the `--track` flag, Embark will execute the script as usual.

For cases in which we **do** want to track a set of scripts, especially when the main use case are migration operations, we can put our scripts in a special "migrations" directory. All scripts inside that directory will be tracked by default.

The directory can be specified using the `migrations` property in your project's embark.json:

```
{
  ...
  migrations: 'migrations'
}
```

If no such property is specified, Embark will default to "migrations". Running any script or set of scripts is then automatically tracked.

For more information check the documentation for [Deployment scripts](https://framework.embarklabs.io/docs/executing_scripts.html)

## Support using $accounts in ens registrations

It's now possible to specify an account to be registered as an ENS domain:

```javascript
config({
  namesystem: {
    enabled: true,
    register: {
      rootDomain: "embark.eth",
      subdomains: {
        "mytoken": "$MyToken",
        "account": "$accounts[0]"
      }
    }
  }
})  
```

## Improved compatibility

In the test suite, in order to improve compatbility with other tools, it is now possible to also use the `artifacts.require` as an alternative to get a smart contract instances:

```javascript
const AnotherStorage = artifacts.require('AnotherStorage');
```

## Transition to Embark 6.0

To make Embark even lighter and faster, starting in Embark 6.0, the following will be installable plugins that will no longer come with Embark by default:

* embark-geth
* embark-graph
* embark-ipfs
* embark-parity
* embark-profiler
* embark-swarm
* embark-whisper-geth
* embarkjs
* embarkjs-ens
* embarkjs-ipfs
* embarkjs-swarm
* embarkjs-web3
* embarkjs-whisper

Embark 5.2 will issue warnings about these needing to be installed & configured as plugins to make transition to Embark 6.0 easier.

To make current projects compatible, **ensure `embark` is added as a `devDependency` to your project**, as well as any plugins. For e.g

In `package.json` add `"embark-geth": "^5.2.2",` to the `devDependencies` section and in `embark.json` add `"embark-geth": {}` to the `plugins` section

## Next

Stay tuned for Embark 6.0 and the latest changes happening by watching the [Embark GitHub repository](https://github.com/embarklabs/embark) and following us on the [Embark Labs Twitter](https://twitter.com/embarkproject)!

## changelog

**Features**

* **@embark/contracts:** add proxyFor property for contracts ([2e8b255](https://github.com/embarklabs/embark/commit/2e8b255))
* **@embark/ens:** enable the use of $accounts in registrations ([de01022](https://github.com/embarklabs/embark/commit/de01022))
* **@embark/test-runner:** introduce artifacts.require API ([b021689](https://github.com/embarklabs/embark/commit/b021689))
* **plugins/scripts-runner:** introduce exec command to run scripts ([40c3d98](https://github.com/embarklabs/embark/commit/40c3d98))
* **@embark/blockchain:** make GanacheCLI the default dev blockchain ([cd934f8](https://github.com/embarklabs/embark/commit/cd934f8))
* warn about packages not configured as plugins; make geth/parity full plugins ([d14e93c](https://github.com/embarklabs/embark/commit/d14e93c))

**Bug Fixes**

* **@embark/blockchain-api:** add back contract event listen and log ([5592753](https://github.com/embarklabs/embark/commit/5592753))
* **@embark/cmd-controller:** exit build if afterDeploy is not array ([5359cc6](https://github.com/embarklabs/embark/commit/5359cc6))
* **@embark/contracts-manager:** Remove `logger` from serialized contract ([d529420](https://github.com/embarklabs/embark/commit/d529420))
* **@embark/contracts-manager:** always deploy contracts with deploy: true ([87a04cd](https://github.com/embarklabs/embark/commit/87a04cd))
* **@embark/dashboard:** update dashboard's `logEntry` to match core/logger's `logFunction` ([63831f6](https://github.com/embarklabs/embark/commit/63831f6)), closes [#2184](https://github.com/embarklabs/embark/issues/2184)
* **@embark/deployment:** fix undefined in nb arguments in deploy ([0016581](https://github.com/embarklabs/embark/commit/0016581))
* **@embark/ens:** fix tests erroring on FIFS contract deploy ([78fc7b6](https://github.com/embarklabs/embark/commit/78fc7b6))
* **@embark/ganache:** fix connection to other nodes from Ganache ([5531b60](https://github.com/embarklabs/embark/commit/5531b60))
* **@embark/logger:** Remove `writeToFile` for logger `dir` ([e9be40c](https://github.com/embarklabs/embark/commit/e9be40c))
* **@embark/proxy:** only up event listeners on available providers ([caae922](https://github.com/embarklabs/embark/commit/caae922))
* **@embark/proxy:** up max listener for proxy request manager ([9c8837d](https://github.com/embarklabs/embark/commit/9c8837d))
* **@embark/test-runner:** fix reporter to only catch gas for txs ([0e30bf3](https://github.com/embarklabs/embark/commit/0e30bf3))
* **core/config:** Fix `EmbarkConfig` type ([0f59e0c](https://github.com/embarklabs/embark/commit/0f59e0c))
* only show account warning when Geth will actually start ([f502650](https://github.com/embarklabs/embark/commit/f502650))
* set helper methods on contracts ([7031335](https://github.com/embarklabs/embark/commit/7031335))
* **stack/contracts-manager:** ensure custom `abiDefinition` is set properly if provided ([b4b4848](https://github.com/embarklabs/embark/commit/b4b4848))
