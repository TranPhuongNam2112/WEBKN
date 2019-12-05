/* eslint-disable */
import web3 from './web3';

const address = '0x2c5b6C82c7ac23625923Edf2D98DA2af73C00C97';
const abi = [
	{
		"constant": true,
		"inputs": [],
		"name": "returnAllProjects",
		"outputs": [
			{
				"name": "",
				"type": "address[]"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "title",
				"type": "string"
			},
			{
				"name": "description",
				"type": "string"
			},
			{
				"name": "durationInDays",
				"type": "uint256"
			},
			{
				"name": "amountToRaise",
				"type": "uint256"
			}
		],
		"name": "startProject",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "contractAddress",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "projectStarter",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "projectTitle",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "projectDesc",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "deadline",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "goalAmount",
				"type": "uint256"
			}
		],
		"name": "ProjectStarted",
		"type": "event"
	}
];

const instance = new web3.eth.Contract(abi, address);

export default instance;
