/* eslint-disable no-console */
import {ethers} from 'hardhat'

async function main() {
    const WhitelistHook = await ethers.getContractFactory('WhitelistHook')
    const whitelistHook = await WhitelistHook.deploy()
    await whitelistHook.waitForDeployment()
    console.log('WhitelistHook deployed to:', await whitelistHook.getAddress())
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
