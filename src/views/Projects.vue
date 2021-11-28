<template lang="html">
    <card
    title="Create a project"
    subtitle="Create your own or your entreprise project"
    :blue="true"
    >
    <router-link class="card-body" to="/create_project">
        Create your project
    </router-link>
    </card>
  <card
    title="Explore Projects"
    subtitle="You can get rewards when you reslove an issue">
    <div v-for="project in projects" v-bind:key="project.name">
    <card>   
      <ProjectCard :project="project"></ProjectCard>
    </card>
    </div>
  </card>

</template>

<script lang="ts">
import { computed, defineComponent } from 'vue'
import Card from '@/components/Card.vue'
import { useStore } from 'vuex'
import ProjectCard from '@/components/ProjectCard.vue'

export default defineComponent({
  name: 'Projects',
  components: { Card, ProjectCard },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  data() {
    const projects: any = []
    return { projects }
  },
  async mounted() {
    const userAddresses = await this.contract.methods.getUsers().call()
    for (const address of userAddresses) {
      const projects = await this.contract.methods.getProjects1(address).call()
      if (projects.length > 0) {
        for (const project of projects) {
          let name = project.name
          let owner = null
          if (project.ownedByUser) {
            owner = await this.contract.methods.getUser(project.owner).call()
          } else {
            owner = await this.contract.methods
              .getEnterprise(project.owner)
              .call()
          }
          let balance = project.balance
          const contributorsAddress = project.contributorsAddress
          let contributors = []
          for (const contributorsAddressKey of contributorsAddress) {
            const contributor = await this.contract.methods
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
          this.projects.push({
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
          })
        }
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
