<template lang="html">

   <transition name="modal">
    <div class="modal-mask">
      <div class="modal-wrapper">
        <div class="modal-container" >
          <div class="modal-header">
            <h2>Enter the number you want to deposit</h2>
          </div>

          <div class="modal-body">
             <div class="home-wrapper" v-if="account">
    <card
      :title="`Welcome ${account.username} `"
      subtitle="Account Information"
      :gradient="true"
    >
      <div class="explanations">
        <p><b>Name of Account: </b>{{ account.username }}</p>
        <p><b>Address: </b>{{ address }}</p>
        <p><b>ETH Balance: </b>{{ (account.balance/1000000000000000000)  }} Tokens</p>
      </div>
            <div class="input-field">

            <div style="margin:0 auto" align=center>
                <p>
                <label for="deposit">Enter the number you want to deposit</label></p>
              <input 
                id="deposit"
                type="text"
                v-model="deposit"
              />
            </div>
            </div>
    </card>
    </div>
          </div>

          <div class="modal-footer">
            <button class="modal-default-button" @click="transfer">
              nb
            </button>
          </div>
        </div>
      </div>
    </div>
  </transition>
 
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'
import Web3 from 'web3'



export default defineComponent({
  name: 'Deposit',
  components: {  Card },
    props: {
    title: String,
    ownerAddress: String,
  },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)

    console.log(address)
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

    return {
      deposit,
      withdraw,
      account,
      username,
      userBalance,
      

    }
  },
  
  
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.getUser(address).call()
    },



    async signUp() {
      const { contract, username, userBalance } = this
      const name = username.trim().replace(/ /g, '_')
      await contract.methods.signUp(name, userBalance).send()
      await this.updateAccount()
      this.username = ''
    },
    async addTokens() {
      const { contract } = this
      await contract.methods.addBalance(200).send()
      await this.updateAccount()
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

      async transfer() {
          console.log(this.ownerAddress);
      const depositValue = Web3.utils.toWei(this.deposit, 'ether')
      if (!depositValue) {
        return
      }

      this.contract.methods
        .AtoB(this.ownerAddress,depositValue)
        .send()
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
.modal-container {
    padding:9px 15px;
    border-bottom:1px solid #eee;
    background-color: #29052e;
    -webkit-border-top-left-radius: 5px;
    -webkit-border-top-right-radius: 5px;
    -moz-border-radius-topleft: 5px;
    -moz-border-radius-topright: 5px;
     border-top-left-radius: 5px;
     border-top-right-radius: 5px;
 }
</style>
