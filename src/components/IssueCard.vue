<template lang="html">
  <div style="padding: 12px">
    <p>Title of Issue: {{ issue.title }}</p>
    <p><b>Description: </b>{{ issue.description }}</p>
    <p><b>URL: </b>{{ issue.url }}</p>
    <p><b>Creator of bounty: </b>{{ issuerUsername }}</p>
    <p><b>Amount of ETH for reward: </b>{{ (issue.reward/1000000000000000000) }} ETHs</p>
    <p>Status: {{ issue.closed ? 'Closed' : 'Open' }}</p>
    <p v-if="issue.closed">Fixer: {{ fixerUsername }}</p>
    <a v-else href="#" style="color: white" @click="showModal = true">
      Declare the issue is fixed by you
    </a>
    <FixIssueWindow :idProject="projectId" :idIssue="issue.id" v-if="showModal"
      @close="showModal = false">
    </FixIssueWindow>
  </div>
</template>

<script lang="ts">
import { computed, defineComponent } from 'vue'
import { useStore } from 'vuex'
import FixIssueWindow from '@/components/FixIssueWindow.vue'

export default defineComponent({
  name: 'IssueCard',
  components: { FixIssueWindow },
  props: { issue: Object, projectId: String },
  data() {
    const issuerUsername = ''
    const fixerUsername = ''
    const showModal = false
    return { issuerUsername, fixerUsername, showModal }
  },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  async mounted() {
    const issuerAddress = this.issue?.issuer
    const issuerAccount = await this.contract.methods.getUser(issuerAddress).call()
    this.issuerUsername = issuerAccount.username
    if (this.issue?.closed) {
      const fixerAddress = this.issue?.fixer
      const fixerAccount = await this.contract.methods.getUser(fixerAddress).call()
      this.fixerUsername = fixerAccount.username
    }
    console.error(this.issue)
  },
})
</script>
