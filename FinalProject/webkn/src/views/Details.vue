<template>
    <div>

        <div class="position-relative">
            <!-- shape Hero -->
            <section class="section-shaped my-0">
                <div class="shape shape-style-1 shape-default shape-skew">
                    <span></span>
                    <span></span>
                    <span></span>
                    <span></span>
                    <span></span>
                    <span></span>
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
                <div class="container shape-container d-flex">
                    <div class="col px-0">
                        <div class="row">
                            <div class="col-lg-6">
                                <h1 class="display-3  text-white">Nơi biến các ước mơ giáo dục của bạn
                                    <span>thành sự thật!</span>
                                </h1>
                                
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- 1st Hero Variation -->
        </div>
        <section class="section section-lg pt-lg-0 mt--200">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-12">
                        <div class="row row-grid">
                            <div class="col-lg-12"  v-for="(project, index) in projectData" :key="index" xs12>
                                <card class="border-0" hover shadow body-classes="py-5">
                                    
                                    <badge type="primary">
                                        {{ stateMap[project.currentState].text }}</badge>
                                    <br/>
                                    <br/>
                                    <h6 class="text-primary text-uppercase">{{ project.projectTitle }}</h6>
                                    <p class="description mt-3">{{ project.projectDesc}}</p>
                                    <div>
                                    <div v-if="project.currentState == 0">
                                    <small>Còn đến ngày: <b>{{ new Date(project.deadline * 1000) }}</b></small>
                                    </div>
                                    <br/>
                                    <small v-if="project.currentState == 1"><b>Deadline: {{ new Date(project.deadline * 1000) }}</b> </small>
  
                                    <small v-if="project.currentState == 2"><b>Deadline: {{ new Date(project.deadline * 1000) }} </b></small>
                                    <br/>
                                    <small v-if="project.currentState == 1">Goal of <b>{{ project.goalAmount / 10**18 }}</b> ETH wasn't achieved before deadline</small>
                                    <small v-if="project.currentState == 2">Goal of <b>{{ project.goalAmount / 10**18 }}</b> ETH has been achieved</small>
                                    <br/>
                                    <br/>
                                    </div>
                                    <div v-if="project.currentState == 0 && account != project.projectStarter"
                                        class="d-flex ml-3" xs12 sm6 md3>
                
                                        <label class="grey-text">Đóng góp:</label>
                                        <br/>
                                        <input class="form-control" v-model="project.fundAmount"/>
                                        <br/>
                                        <button class="btn btn-indigo" type="submit" @click="fundProject(index)"
                                        :loading="project.isLoading">Fund</button>
                                    </div>
                                    <br/>
                                    <div class="d-flex ml-3" xs12 sm6 md3 v-if="project.currentState == 1 && project.currentAmount > 0">
                                      <button class="btn btn-indigo" type="submit" v-on:click="getRefund(index)">Get Refund</button>
                                    </div>
                                    <div v-if="project.currentState == 0" class="text-xs-center">
                                    <span class="font-weight-bold" style="width: 200px;">
                                        {{ project.currentAmount / 10**18 }} ETH
                                    </span>
                                    <base-progress :value="(project.currentAmount / project.goalAmount) * 100"></base-progress>
                                    <span class="font-weight-bold" style="width: 200px;">
                                        {{ project.goalAmount / 10**18 }} ETH
                                    </span>
                                    </div>
                                    </card>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

    </div>
</template>

<script>
// We import our the scripts for the smart contract instantiation, and web3
import crowdfundInstance from '../../contracts/crowdfundInstance';
import crowdfundProject from '../../contracts/crowdfundProjectInstance';
import web3 from '../../contracts/web3';
import { serverBus } from '../main'
export default {
  name: "home",
  components: {},
  data() {
    return {
      startProjectDialog: false,
      account: null,
      stateMap: [
        { color: 'primary', text: 'Ongoing' },
        { color: 'warning', text: 'Expired' },
        { color: 'success', text: 'Completed' },
      ],
      projectData: [],
      newProject: { isLoading: false },
    };
  },
  mounted() {
    // this code snippet takes the account (wallet) that is currently active
    web3.eth.getAccounts().then((accounts) => {
      [this.account] = accounts;
      this.getProjects();
    });
  },
  methods: {
    getProjects() {
      crowdfundInstance.methods.returnAllProjects().call().then((projects) => {
        projects.forEach((projectAddress) => {
          const projectInst = crowdfundProject(projectAddress);
          projectInst.methods.getDetails().call().then((projectData) => {
            const projectInfo = projectData;
            projectInfo.isLoading = false;
            projectInfo.contract = projectInst;
            this.projectData.push(projectInfo);
          });
        });
      });
    },
    startProject() {
      this.newProject.isLoading = true;
      crowdfundInstance.methods.startProject(
        this.newProject.title,
        this.newProject.description,
        this.newProject.duration,
        web3.utils.toWei(this.newProject.amountGoal, 'ether'),
      ).send({
        from: this.account,
      }).then((res) => {
        const projectInfo = res.events.ProjectStarted.returnValues;
        projectInfo.isLoading = false;
        projectInfo.currentAmount = 0;
        projectInfo.currentState = 0;
        projectInfo.contract = crowdfundProject(projectInfo.contractAddress);
        this.startProjectDialog = false;
        this.newProject = { isLoading: false };
      });
    },
    fundProject(index) {
      if (!this.projectData[index].fundAmount) {
        return;
      }

      const projectContract = this.projectData[index].contract;
      this.projectData[index].isLoading = true;
      projectContract.methods.contribute().send({
        from: this.account,
        value: web3.utils.toWei(this.projectData[index].fundAmount, 'ether'),
      }).then((res) => {
        const newTotal = parseInt(res.events.FundingReceived.returnValues.currentTotal, 10);
        const projectGoal = parseInt(this.projectData[index].goalAmount, 10);
        this.projectData[index].currentAmount = newTotal;
        this.projectData[index].isLoading = false;

        // Set project state to success
        if (newTotal >= projectGoal) {
          this.projectData[index].currentState = 2;
        }
      });
    },
    getRefund(index) {
      this.projectData[index].isLoading = true;
      this.projectData[index].contract.methods.getRefund().send({
        from: this.account,
      }).then(() => {
        this.projectData[index].isLoading = false;
      });
    },
    
  },
};
</script>
