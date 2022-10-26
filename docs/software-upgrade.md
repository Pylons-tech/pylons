# Run UpgradeHandler using Proposals

To run the upgrade, you should be on the pre-release version of the binary.

## Draft a Proposal

Draft a proposal for using the command.

```
pylonsd tx gov draft-proposal
```

Select proposal type `software-upgrade`

```
? Select proposal type:
    text
  ▸ software-upgrade
    cancel-software-upgrade
    other
```

## Fill Proposal detail

Please add the details to the proposal. The `title` of the proposal should be the same as the `UpgradeName` in `app/upgrade/constant.go` in the new version of the binary that contains the upgrade logic.

```
✔ software-upgrade
Enter proposal title: mainnet
✔ Enter proposal authors: test
Enter proposal summary: pylons-upgrade
Enter proposal summary: pylons-upgrade
Enter proposal details: upgrading chain
Enter proposal proposal forum url: https://www.pylons.tech/home/
Enter proposal vote option context: YES: XX, NO: YX, ABSTAIN: XY, NO_WITH_VETO: YY
✔ Enter msg authority: pylo10d07y265gmmuvt4z0w9aw880jnsr700jrcygjh
Your draft proposal has successfully been generated.
Proposals should contain off-chain metadata, please upload the metadata JSON to IPFS.
Then, replace the generated metadata field with the IPFS CID.
```

Two files `draft_metadata.json` `draft_proposal.json` will be generated.

## Replace metadata value in draft_proposal.json

Upload the `draft_metadata.json` on IPFS, copy the CID value and replace it in the metadata field in `draft_proposal.json`.

![IPFS](/docs/static/ipfs.png)

```
{
 "messages": [
  {
   "@type": "/cosmos.upgrade.v1beta1.MsgSoftwareUpgrade",
   "authority": "pylo10d07y265gmmuvt4z0w9aw880jnsr700jrcygjh",
   "plan": {
    "name": "",
    "time": "0001-01-01T00:00:00Z",
    "height": "0",
    "info": "",
    "upgraded_client_state": null
   }
  }
 ],
 "metadata": "ipfs://QmbE44is7hkfE4gzChxCUic5UCp3ZPFozjtheZPK3VYG45",
 "deposit": "10ubedrock"
}
```

To run and configure IPFS locally, please refer to this doc: https://blockchainmind.medium.com/insatallation-procedure-of-ipfs-in-ubuntu-platform-e83cff0d387b

## Add details in Draft_Proposal.json

`name` field should be the same as the `UpgradeName` in `app/upgrade/constant.go` in the new version of the binary that contains the upgrade logic. `height` will be the block height where the chain will halt. `info` is the detail of the proposal.

```
{
 "messages": [
  {
   "@type": "/cosmos.upgrade.v1beta1.MsgSoftwareUpgrade",
   "authority": "pylo10d07y265gmmuvt4z0w9aw880jnsr700jrcygjh",
   "plan": {
    "name": "mainnet",
    "time": "0001-01-01T00:00:00Z",
    "height": "50",
    "info": "mainnet",
    "upgraded_client_state": null
   }
  }
 ],
 "metadata": "ipfs://QmbE44is7hkfE4gzChxCUic5UCp3ZPFozjtheZPK3VYG45",
 "deposit": "10ubedrock"
}
```

## Submit the proposal

The command to submit the proposal is

```
pylonsd tx gov submit-proposal draft_proposal.json  --from test --keyring-backend test
```

## Query the proposal status

Command to query the proposal status.

```
pylonsd q gov proposal 1
```

`1` the proposal id.
Output

```
deposit_end_time: "2022-10-26T11:02:39.077855606Z"
final_tally_result:
  abstain_count: "0"
  no_count: "0"
  no_with_veto_count: "0"
  yes_count: "0"
id: "1"
messages:
- '@type': /cosmos.upgrade.v1beta1.MsgSoftwareUpgrade
  authority: pylo10d07y265gmmuvt4z0w9aw880jnsr700jrcygjh
  plan:
    height: "50"
    info: mainnet
    name: mainnet
    time: "0001-01-01T00:00:00Z"
    upgraded_client_state: null
metadata: ipfs://QmbE44is7hkfE4gzChxCUic5UCp3ZPFozjtheZPK3VYG45
status: PROPOSAL_STATUS_DEPOSIT_PERIOD
submit_time: "2022-10-26T11:00:39.077855606Z"
total_deposit:
- amount: "10"
  denom: ubedrock
voting_end_time: null
voting_start_time: null
```

The `status` is `PROPOSAL_STATUS_DEPOSIT_PERIOD` .

## Deposit amount in the Proposal.

Deposit the `amount` in the proposal set in the `genesis.json` file.
Command to deposit amount.

```
pylonsd tx gov deposit 1  1000ubedrock --from test --yes --chain-id pylons-testnet-1
```

`1` the proposal id. Now query the proposal.

## Query the proposal status

Command to query the proposal status.

```
pylonsd q gov proposal 1
```

Output

```
deposit_end_time: "2022-10-26T11:02:39.077855606Z"
final_tally_result:
  abstain_count: "0"
  no_count: "0"
  no_with_veto_count: "0"
  yes_count: "0"
id: "1"
messages:
- '@type': /cosmos.upgrade.v1beta1.MsgSoftwareUpgrade
  authority: pylo10d07y265gmmuvt4z0w9aw880jnsr700jrcygjh
  plan:
    height: "50"
    info: mainnet
    name: mainnet
    time: "0001-01-01T00:00:00Z"
    upgraded_client_state: null
metadata: ipfs://QmbE44is7hkfE4gzChxCUic5UCp3ZPFozjtheZPK3VYG45
status: PROPOSAL_STATUS_VOTING_PERIOD
submit_time: "2022-10-26T11:00:39.077855606Z"
total_deposit:
- amount: "1010"
  denom: ubedrock
voting_end_time: "2022-10-26T11:04:14.463088707Z"
voting_start_time: "2022-10-26T11:02:14.463088707Z"
```

The `status` is `PROPOSAL_STATUS_VOTING_PERIOD` .

## Vote for the proposal

Command to vote for the proposal

```
pylonsd tx gov vote 1 yes --from test --yes
```

## Query the proposal status

Command to query the proposal status.

```
pylonsd q gov proposal 1
```

Output

```
deposit_end_time: "2022-10-26T11:23:14.153284715Z"
final_tally_result:
  abstain_count: "0"
  no_count: "0"
  no_with_veto_count: "0"
  yes_count: "1000000"
id: "2"
messages:
- '@type': /cosmos.upgrade.v1beta1.MsgSoftwareUpgrade
  authority: pylo10d07y265gmmuvt4z0w9aw880jnsr700jrcygjh
  plan:
    height: "50"
    info: mainnet
    name: mainnet
    time: "0001-01-01T00:00:00Z"
    upgraded_client_state: null
metadata: ipfs://QmbE44is7hkfE4gzChxCUic5UCp3ZPFozjtheZPK3VYG45
status: PROPOSAL_STATUS_PASSED
submit_time: "2022-10-26T11:21:14.153284715Z"
total_deposit:
- amount: "1010"
  denom: ubedrock
voting_end_time: "2022-10-26T11:24:04.373103668Z"
voting_start_time: "2022-10-26T11:22:04.373103668Z"
```

## Proposal Passed

Check the status of the proposal. The `status` will be `PROPOSAL_STATUS_PASSED`

## Halt Chain

The chain will halt when it reaches the `height` mentioned in the proposal.

## Update the binary file

Now, restart the chain on the binary of the new release which contains the `UpgradeName` mentioned in the proposal.