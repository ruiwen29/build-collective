<template lang="html">
  <form @submit.prevent="CreateEntreprise">
    <card
      title="Enter your company name here"
    >
      <input
        type="text"
        class="input-username"
        v-model="enterpriseName"
        placeholder="Enterprise name"
      />
      <span class="input-username">Choose one or multiple members</span>
      <div
        v-for="user in users"
        v-bind:key="user.address"
        class="input-username"
      >
        <input
          type="checkbox"
          :id="user.address"
          :value="user.address"
          v-model="enterpriseMembers"
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
  name: 'CreateEntreprise',
  components: { Card },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const contract = computed(() => store.state.contract)
    return { address, contract }
  },
  data() {
    const users: any[] = []
    const enterpriseAccount = null
    const enterpriseName = ''
    const enterpriseMembers: never[] = []
    return {
      enterpriseName,
      users,
      enterpriseAccount,
      enterpriseMembers,
    }
  },
  methods: {
    async updateEnterpriseAccount() {
      const { address, contract } = this
      this.enterpriseAccount = await contract.methods
        .getEnterprise(address)
        .call()
    },
    async CreateEntreprise() {
      const { contract, enterpriseName, enterpriseMembers } =
        this
      const name = enterpriseName.trim().replace(/ /g, '_')
      await contract.methods
        .CreateEntreprise(name, enterpriseMembers)
        .send()
      await this.updateEnterpriseAccount()
      await this.$router.push({ name: 'Account' })
    },
  },
  async mounted() {
    const { address, contract } = this
    this.enterpriseAccount = await contract.methods
      .getEnterprise(address)
      .call()
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
