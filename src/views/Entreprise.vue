<template lang="html">
  <div class="home-wrapper" v-if="account">
    
    <card
      title="Your Enterprise"
      subtitle="You can find your enterprise information here"
      v-if="enterpriseAccount"
    >
      <div class="explanations" v-if="enterpriseAccount">
        <h2>Enterprise Information</h2>
        <p><b>Name of Enterprise: </b>{{ enterpriseAccount.name }}</p>
        <p><b>Owner: </b>{{ this.enterpriseOwnerAccount.username }}</p>
        <div>
          <b>Members: </b>
          <p
            v-for="member in enterpriseMembers"
            v-bind:key="member.address"
            style="padding-left: 10px"
          >
            Account Name: {{ member.account.username }} &nbsp; Address:
            {{ member.address }}
          </p>
        </div>
        <p><b>Balance: </b>{{ (enterpriseAccount.balance/1000000000000000000) }} Tokens</p>
      </div>

      <p>
        <a href="#" style="color: white" class="card-body" @click="showModalDeposit = true">
          DEPOSIT ETH
        </a>
      </p>
      <Deposit
        :account="this.enterpriseAccount"
        v-if="showModalDeposit"
        @close="showModalDeposit = false; updateEnterpriseAccount()"
      >
      </Deposit>
        
      <p>
        <a href="#" style="color: white" class="card-body" @click="showModalWithDraw = true">
          WITHDRAW ETH
        </a>
      </p>
      <Withdraw
        :account="this.enterpriseAccount"
        v-if="showModalWithDraw"
        @close="showModalWithDraw = false; updateEnterpriseAccount()"
      >
      </Withdraw>
    

    </card>
   
    <div class="home">
      <card
        title="Create an enterprise"
        :blue="true"
        v-if="!enterpriseAccount"
      >
        <router-link class="card-body" to="/create_entreprise">
          Create your enterprise
        </router-link>
      </card>


    </div>
  </div>

</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'
import Deposit from '@/components/DepositCard.vue'
import Withdraw from '@/components/WithdrawCard.vue'


export default defineComponent({
  name: 'Entreprise',
  components: { Card,Deposit,Withdraw },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  data() {
    const account = null
    const username = ''
    const userBalance = ''
    const enterpriseOwnerAccount: any = { username: '', balance: 0 }
    const enterpriseAccount = null
    const enterpriseMembers: any[] = []
    const projects: any[] = []
    const showModalDeposit = false
    const showModalWithDraw = false
    return {
      account,
      username,
      userBalance,
      enterpriseOwnerAccount,
      enterpriseAccount,
      enterpriseMembers,
      projects,
      showModalDeposit,
      showModalWithDraw
    }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.getUser(address).call()
    },
    async updateEnterpriseAccount() {
      const { address, contract } = this
      this.enterpriseAccount = await contract.methods
        .getEnterprise(address)
        .call()
    },
    getMembersAccount(addressMember: string) {
      return this.contract.methods.getUser(addressMember).call()
    },
    

  },
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.getUser(address).call()
    if (account.registered) this.account = account
    const enterpriseAccount = await contract.methods
      .getEnterprise(address)
      .call()
    if (enterpriseAccount.name) {
      this.enterpriseAccount = enterpriseAccount
      this.enterpriseOwnerAccount = await contract.methods.getUser(enterpriseAccount.owner).call()
      const membersAddress = enterpriseAccount.membersAddress
      for (const membersAddressKey of membersAddress) {
        const member = await contract.methods
          .getUser(membersAddressKey)
          .call()
        this.enterpriseMembers.push({
          address: membersAddressKey,
          account: {
            username: member.username,
            balance: member.balance
          },
        })
      }
    }

  },
})
</script>

<style lang="css" scoped>
.home-wrapper {
  margin: auto 24px auto 24px;
}
.home {
  display: grid;
  align-items: center;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  grid-gap: 24px;
}
.card-body {
  padding: 12px;
  display: block;
  font-family: inherit;
  font-size: 1.2rem;
  font-weight: inherit;
  text-align: center;
  color: inherit;
  text-decoration: none;
  font-variant: small-caps;
}
.signUp {
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
