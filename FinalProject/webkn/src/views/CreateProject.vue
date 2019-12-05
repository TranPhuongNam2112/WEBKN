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
                                <div class="btn-wrapper">
                                    <base-button tag="a"
                                                 href="https://demos.creative-tim.com/argon-design-system/docs/components/alerts.html"
                                                 class="mb-3 mb-sm-0"
                                                 type="info"
                                                 icon="fa fa-code">
                                        Components
                                    </base-button>
                                    <base-button tag="a"
                                                 href="https://www.creative-tim.com/product/argon-design-system"
                                                 class="mb-3 mb-sm-0"
                                                 type="white"
                                                 icon="ni ni-cloud-download-95">
                                        Download HTML
                                    </base-button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <section class="section section-lg pt-lg-0 mt--200">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-12">
                            <form>
                                <p class="h4 text-center mb-4">Hãy tạo dự án của chính bạn nào!</p>
                                <label class="grey-text">Tên dự án</label>
                                <input class="form-control" v-model="newProject.title"/>
                                <br/>
                                <label class="gret-text">Mô tả dự án</label>
                                <br/>
                                <textarea rows='10' cols='123' style='resize:none' v-model="newProject.description"></textarea>
                                <br/>
                                <label class="grey-text">Số tiền cần gây quỹ</label>
                                <br/>
                                <input class="form-control" v-model="newProject.amountGoal"/>
                                <br/>
                                <label class="grey-text">Số ngày</label>
                                <br/>
                                <input class="form-control" v-model="newProject.duration"/>
                                <router-link to="/landing">
                                <div class="text-center mt-4">
                    
                                <button class="btn btn-indigo" type="submit" v-on:click="startProject"
                                :loading="newProject.isLoading"
                                >Save</button>
                                </div>
                                </router-link>
                            </form>
                           
                        
                    </div>
                </div>
            </div>
        </section>
        </div>
    </div>
</template>
<script>
// We import our the scripts for the smart contract instantiation, and web3
import crowdfundInstance from '../../contracts/crowdfundInstance';
import crowdfundProject from '../../contracts/crowdfundProjectInstance';
import web3 from '../../contracts/web3';


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