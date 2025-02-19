<template lang="html">
  <div class="home-wrapper" v-if="account">
    <card
      :title="`Welcome ${account.username} `"
      subtitle="Account Information"
      :gradient="true"
    >
      <div class="explanations">
        <p><b> Account ID: </b>{{ account.username }}</p>
        <p><b>ETH Balance: </b>{{ (account.balance/1000000000000000000)  }} </p>
      </div>
 

      <p>
        <a href="#" style="color: white" class="card-body" @click="showModalDeposit = true">
          DEPOSIT ETH
        </a>
      </p>
      <Deposit
        :account="this.account"
        v-if="showModalDeposit"
        @close="showModalDeposit = false; updateAccount()"
      >
      </Deposit>
        
      <p>
        <a href="#" style="color: white" class="card-body" @click="showModalWithDraw = true">
          WITHDRAW ETH
        </a>
      </p>
      <Withdraw
        :account="this.account"
        v-if="showModalWithDraw"
        @close="showModalWithDraw = false; updateAccount()"
      >
      </Withdraw>


    </card>
    

    <div class="home">
      <card
        title="Entreprise Information"
        subtitle="Exploration of the entreprise"
        :blue="true"
      >
        <router-link class="card-body" to="/Entreprise">
          Check enterprises
        </router-link>
      </card>
      <card
        title="Projects Information"
        subtitle="Exploration of projects created"
        :blue="true"
      >
        <router-link class="card-body" to="/Projects">
          Check projects
        </router-link>
      </card>

    </div>
  </div>
  <div class="signUp" v-else>
    <form @submit.prevent="signUp">
      <card
        title="Create an user account"
        subtitle="With a name and a balance of tokens"
      >
        <input
          type="text"
          class="input-username"
          v-model="username"
          placeholder="Username"
        />

        <button type="submit" class="input-username">Submit</button>
      </card>
    </form>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'
import Web3 from 'web3'
import Deposit from '@/components/DepositCard.vue'
import Withdraw from '@/components/WithdrawCard.vue'



export default defineComponent({
  name: 'Account',
  components: {  Card,Deposit,Withdraw },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)

    console.log(balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance ,
}
  },
  
  data() {
    const account = null
    const username = ''
    const userBalance = ''
    const deposit = ''
    const withdraw = ''
    const showModalDeposit = false
    const showModalWithDraw = false

    return {
      deposit,
      withdraw,
      account,
      username,
      userBalance,
      showModalDeposit,
      showModalWithDraw,
    }
  },
  
  
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.getUser(address).call()
    },



    async signUp() {
      const { contract, username } = this
      const name = username.trim().replace(/ /g, '_')
      await contract.methods.signUp(name).send()
      await this.updateAccount()
      this.username = ''
    },

      async sendWithdraw() {
      const withdrawValue = Web3.utils.toWei(this.withdraw, 'ether')
      if (!withdrawValue) {

        return
      }

      this.contract.methods
        .withdraw(withdrawValue)
        .send()
        .then(this.updateAccount)
        .catch((e: Error) => {
          console.error(e)
        })

      this.withdraw = ''
    },

      async sendDeposit() {
      const depositValue = Web3.utils.toWei(this.deposit, 'ether')
      if (!depositValue) {
        return
      }

      this.contract.methods
        .deposit()
        .send({ value: depositValue })
        .then(this.updateAccount)
        .catch((e: Error) => {
          console.error(e)
        })

      this.deposit = ''
    },
  },
  async mounted() {


    const { address, contract } = this
    const account = await contract.methods.getUser(address).call()
    if (account.registered) this.account = account


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
