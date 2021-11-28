<template lang="html">
  <transition name="modal">
    <div class="modal-mask">
      <div class="modal-wrapper">
        <div class="modal-container">
          <div class="modal-header">
            <h2>Declaration of resloving issue</h2>
          </div>

          <div class="modal-body">
            <h3>Once you confirm the declaration you can get the reward.</h3>
            <button class="modal-default-button" style="color: red" @click="fixIssue">
              Confirm
            </button>
          </div>

          <div class="modal-footer">
            <button class="modal-default-button" @click="this.$emit('close')">
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script lang="ts">
import { computed, defineComponent } from 'vue'
import { useStore } from 'vuex'

export default defineComponent({
  name: 'FixIssueWindow',
  props: {
    idProject: String,
    idIssue: String,
  },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const contract = computed(() => store.state.contract)
    return { address, contract }
  },
  data() {
    const error = false
    const balance = 0
    const amount = 100
    return { error, balance, amount }
  },
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.getUser(address).call()
    this.balance = account.balance
  },
  methods: {
    async fixIssue() {
      const { contract } = this

      await contract.methods.fixIssue(this.idProject, this.idIssue).send()
      console.log(await contract.methods.fixIssue(this.idProject, this.idIssue).call())

      this.$emit('close')
      location.reload()

    },
  },
})
</script>

<style lang="css">
.modal-mask {
  position: fixed;
  z-index: 9998;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: table;
  transition: opacity 0.3s ease;
}

.modal-wrapper {
  display: table-cell;
  vertical-align: middle;
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

.modal-header {
  margin-top: 0;
  color: #eee;
}

.modal-body {
  margin: 20px 0;
  color: eee;
}

.modal-footer {
  margin-bottom: 40px;
}

.modal-default-button {
  float: right;
  margin-left: 10px;
}

.modal-enter {
  opacity: 0;
}

.modal-leave-active {
  opacity: 0;
}

.modal-enter .modal-container,
.modal-leave-active .modal-container {
  -webkit-transform: scale(1.1);
  transform: scale(1.1);
}

.input-username {
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  width: 100%;
  color: #42b983;
  font-family: inherit;
  font-size: 1.3rem;
}
</style>
