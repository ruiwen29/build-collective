<template lang="html">
    <transition name="modal">
    <div class="modal-mask">
      <div class="modal-wrapper">
        <div class="modal-container">
          <div class="modal-header">
            <form @submit.prevent="createIssue">
              <card
                title="Create a bounty"
              >
                <label class="input-username">Title of the Issue</label>
                <input
                  type="text"
                  class="input-username"
                  v-model="title"
                  placeholder="Title"
                />
                <label class="input-username">Descripte your problem</label>
                <textarea class="input-username" v-model="description" />
                <label class="input-username">URL</label>
                <input type="text" class="input-username" v-model="link" placeholder="link of issue" />
                <label class="input-username">Reward ETH :</label>
                <input type="number" class="input-username" v-model="reward"/>
                <button type="submit" class="input-username">Submit</button>
              </card>
            </form>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script lang="ts">
import { computed, defineComponent } from 'vue'
import Card from '@/components/Card.vue'
import { useStore } from 'vuex'

export default defineComponent({
  props: { id: String, ownerAddress: String },

  name: 'CreateIssue',
  components: { Card },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const contract = computed(() => store.state.contract)
    return { address, contract }
  },
  data() {
 
    const title = ''
    const description = ''
    const link = ''
    const reward = 0
    return {  title, description, link, reward }
  },
  methods: {
    async createIssue() {
      const { contract, id, ownerAddress, title, description, link, reward } =
        this
      await contract.methods
        .createIssue(ownerAddress, id, title, description, link, reward)
        .send()
      this.$router.push({
        name: 'ProjectDetail',
        query: {
          id: this.id,
          ownerAddress: this.ownerAddress,
        }
      })
      this.$emit('close')

    },
  },
})
</script>

<style lang="css">
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
