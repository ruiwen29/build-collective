<template lang="html">
  <form @submit.prevent="createProject">
    <card
      title="Create a project"
    >
      <div v-if="enterpriseAccount">
        <span class="input-username"
          >Choose the project type</span
        >
        <div class="input-username">
          <input
            type="radio"
            id="user"
            v-bind:value="true"
            v-model="ownedByUser"
          />
          <label for="user">Yourself: {{ account.username }}</label>
        </div>
        <div class="input-username">
          <input
            type="radio"
            id="enterprise"
            v-bind:value="false"
            v-model="ownedByUser"
          />
          <label for="enterprise"
            >Your enterprise: {{ enterpriseAccount.name }}</label
          >
        </div>
      </div>
      <input
        type="text"
        class="input-username"
        v-model="projectName"
        placeholder="Project name"
      />
      <input
        type="text"
        class="input-username"
        v-model="projectLink"
        placeholder="URL"
      />
      <span class="input-username">Choose contributors</span>
      <div
        v-for="user in users"
        v-bind:key="user.address"
        class="input-username"
      >
        <input
          type="checkbox"
          :id="user.address"
          :value="user.address"
          v-model="projectContributors"
        />
        <span>{{ user.account.username }}</span>
      </div>

      <button type="submit" class="input-username">Submit</button>
    </card>
  </form>
</template>

<script lang="ts">
import { computed, defineComponent } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'

export default defineComponent({
  name: 'CreateProject',
  components: { Card },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const contract = computed(() => store.state.contract)
    return { address, contract }
  },
  data() {
    const account = null
    const users: any[] = []
    const enterpriseAccount = null
    const project = null
    const ownedByUser = 'true'
    const projectName = ''
    const projectBalance = ''
    const projectLink = ''
    const projectContributors: never[] = []
    return {
      account,
      enterpriseAccount,
      project,
      users,
      ownedByUser,
      projectName,
      projectBalance,
      projectLink,
      projectContributors,
    }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.getUser(address).call()
    },
    async createProject() {
      const {
        contract,
        projectName,
        ownedByUser,
        projectLink,
        projectContributors,
      } = this
      const name = projectName.trim().replace(/ /g, '_')
      await contract.methods
        .projectCreate(
          name,
          projectLink,
          ownedByUser,
          projectContributors,
          
        )
        .send()
      await this.$router.push({ name: 'Account' })
    },
  },
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.getUser(address).call()
    if (account.registered) this.account = account
    const enterpriseAccount = await contract.methods
      .getEnterprise(address)
      .call()
    if (enterpriseAccount.name) this.enterpriseAccount = enterpriseAccount
    const userAddresses = await contract.methods.getUsers().call()
    for (const userAddressesKey of userAddresses) {
      const account = await contract.methods
        .getUser(userAddressesKey)
        .call()
      this.users.push({ address: userAddressesKey, account: account })
    }
  },
})
</script>

<style lang="css" scoped>
.home {
  padding: 24px;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 100%;
  margin: auto;
}

.explanations {
  padding: 12px;
}

.button-link {
  display: inline;
  appearance: none;
  border: none;
  background: none;
  color: inherit;
  text-decoration: underline;
  font-family: inherit;
  font-size: inherit;
  font-weight: inherit;
  padding: 0;
  margin: 0;
  cursor: pointer;
}

.select-type,
.input-username {
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  width: 100%;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}
</style>
