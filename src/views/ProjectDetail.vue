<template lang="html">
  <card
    title="Project Information"
    :subtitle="`${this.project.name} \t\t ${this.project.balance} Tokens`"
  >
    <div style="padding: 12px">
      <h2>Project Information</h2>
      <p><b>Name of Project: </b>{{ this.project.name }}</p>
      <p>
        <b>Owner of Project: </b>
        {{
          this.project.ownedByUser
            ? this.project.owner.username
            : this.project.owner.name
        }}
        &nbsp;

      </p>
      <div>
        <b>Contributors: </b>
        <p
          v-for="contributor in this.project.contributors"
          v-bind:key="contributor.address"
          style="padding-left: 10px"
        >
          Account Name: {{ contributor.account.username }} &nbsp; 
        </p>
      </div>
      <p><b>Balance of Project: </b>{{ (this.project.balance/1000000000000000000) }} ETH</p>
      <b v-if="issues.length > 0">Bounties: </b>
      <div
        v-for="issue in this.issues"
        v-bind:key="issue.id"
      >
      <card>
        <IssueCard :issue="issue" :projectId="project.id"></IssueCard>
      </card>
      </div>
      <p>
        <a href="#" style="color: white" @click="showModalCreateIssue = true">
          Create bounty 
        </a>
      </p>
      
      <CreateIssue
        :id = "project.id"
        :ownerAddress = "this.project.ownerAddress"
        v-if="showModalCreateIssue"
        @close="showModalCreateIssue = false; showModalCreateIssue"
        >
      </CreateIssue>
      <p>
        <a href="#" style="color: white" @click="showModalSponsorWindow = true">
          Sponsor
        </a>

      </p>
      <SponsorWindow
        :id-project="this.project.id"
        :owner-address="this.project.ownerAddress"
        v-if="showModalSponsorWindow"
        @close="showModalSponsorWindow = false; updateProjectBalance"
      >
      </SponsorWindow>

      <Transfer
        :id-project="this.project.id"
        :ownerAddress="this.project.ownerAddress"
        v-if="false"
        @close="showModal = false; updateProjectBalance"
      >
      </Transfer>
    </div>
  </card>
</template>

<script lang="ts">
import { computed, defineComponent } from 'vue'
import Card from '@/components/Card.vue'
import { useStore } from 'vuex'
import SponsorWindow from '@/components/SponsorWindow.vue'
import Transfer from '@/components/TransferCard.vue'
import IssueCard from '@/components/IssueCard.vue'
import CreateIssue from '@/views/CreateIssue.vue'
export default defineComponent({
  name: 'ProjectDetail',
  components:{ Card ,IssueCard ,SponsorWindow,Transfer ,CreateIssue},
  methods: {
    async updateProjectBalance() {
      const project = await this.contract.methods
        .getProjects2(this.ownerAddress, this.id)
        .call()
      this.project.balance = project.balance
    },
    async createIssue() {
      this.$router.push({
        name: 'CreateIssue',
        query: {
          id: this.project?.id,
          ownerAddress: this.project?.ownerAddress,
        }
      })
    },
    async getIssues(){
        const { contract, id, ownerAddress } = this
        this.issues = await contract.methods.getIssues(id).call()  
        console.log(this.issues[0])
    }
  },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  data() {
    const showModalSponsorWindow = false
    const showModalCreateIssue = false
    const id = this.$route.query.id
    const ownerAddress = this.$route.query.ownerAddress
    const project: any = {
      id: '',
      name: '',
      owner: {
        name: '',
        username: '',
        balance: 0,
      },
      ownerAddress: 'project.owner',
      ownedByUser: true,
      balance: 0,
      contributors: [],
    }
    //const project = JSON.parse(this.$route.params.project.toString())
    const issues: never[] = []
    return { showModalSponsorWindow,showModalCreateIssue ,id, ownerAddress, project, issues }
  },
  async mounted() {
    const { contract, id, ownerAddress } = this
    this.issues = await contract.methods.getIssues(id).call()

    const project = await contract.methods
      .getProjects2(ownerAddress, id)
      .call()
    let name = project.name
    let owner = null
    if (project.ownedByUser) {
      owner = await contract.methods.getUser(project.owner).call()
    } else {
      owner = await contract.methods
        .getEnterprise(project.owner)
        .call()
    }
    let balance = project.balance
    const contributorsAddress = project.contributorsAddress
    let contributors = []
    for (const contributorsAddressKey of contributorsAddress) {
      const contributor = await contract.methods
        .getUser(contributorsAddressKey)
        .call()
      contributors.push({
        address: contributorsAddressKey,
        account: {
          username: contributor.username,
          balance: contributor.balance,
          registered: contributor.registered,
        },
      })
    }
    this.project = {
      id: project.id,
      name: name,
      owner: {
        name: owner.name || undefined,
        username: owner.username || undefined,
        balance: owner.balance,
      },
      ownerAddress: project.owner,
      ownedByUser: project.ownedByUser,
      balance: balance,
      contributors: contributors,
    }
    console.log(this.project)
  },
})
</script>
