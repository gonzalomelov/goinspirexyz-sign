/* eslint-disable no-console */
import {ethers} from 'hardhat'

async function main() {
    const Factory = await ethers.getContractFactory('ActuallyMetIRL')
    const instance = await Factory.deploy()
    const contract = await instance.waitForDeployment()
    console.log(await contract.getAddress())
}

void main()
