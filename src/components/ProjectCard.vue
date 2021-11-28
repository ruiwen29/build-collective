<template lang="html">
  <div style="padding: 12px">
    <p><b>Name of Project: </b>{{ project.name }}</p>
    <p>
      <b>Owner of Project: </b>
      {{ project.ownedByUser ? project.owner.username : project.owner.name }}
    </p>
    <div>
      <b>Contributors: </b>
      <p
        v-for="contributor in project.contributors"
        v-bind:key="contributor.address"
        style="padding-left: 10px"
      >
         {{ contributor.account.username }} &nbsp; 
      </p>
    </div>
   
    <a href="#" style="color: white" @click="ProjectDetail()">
      DETAIL
    </a>
  </div>
</template>

<script lang="ts">
import { computed, defineComponent } from 'vue'
import { useStore } from 'vuex'

export default defineComponent({
  name: 'ResumeProject',
  props: { project: Object },
  methods: {
    ProjectDetail() {
      this.$router.push({
        name: 'ProjectDetail',
        query: {
          id: this.project?.id,
          ownerAddress: this.project?.ownerAddress,
        }
      })
    },
  },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
})
</script>
