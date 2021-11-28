import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import store from '@/store'
import SignIn from '@/views/SignIn.vue'
import Entreprise from '@/views/Entreprise.vue'
import CreateEntreprise from '@/views/CreateEntreprise.vue'
import Projects from '@/views/Projects.vue'
import CreateProject from '@/views/CreateProject.vue'
import ProjectDetail from '@/views/ProjectDetail.vue'
import CreateIssue from '@/views/CreateIssue.vue'
import WithdrawCard from '@/components/WithdrawCard.vue'
import DepositCard from '@/components/DepositCard.vue'

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'SignIn',
    component: SignIn,
  },
  {
    path: '/account',
    name: 'Account',
    component: () => import('@/views/Account.vue'),
  },
  {
    path: '/entreprise',
    name: 'Entreprise',
    component: Entreprise,
  },
  {
    path: '/create_entreprise',
    name: 'CreateEntreprise',
    component: CreateEntreprise,
  },
  {
    path: '/projects',
    name: 'Projects',
    component: Projects,
  },
  {
    path: '/create_project',
    name: 'CreateProject',
    component: CreateProject,
  },
  {
    path: '/project_detail',
    name: 'ProjectDetail',
    component: ProjectDetail,
    props: false,
  },
  {
    path: '/create_issue',
    name: 'CreateIssue',
    component: CreateIssue,
    props: false,
  },
  {
    path: '/deposit',
    name: 'DepositCard',
    component: DepositCard,
    props: false,
  },
  {
    path: '/withdraw',
    name: 'WithdrawCard',
    component: WithdrawCard,
    props: false,
  },


]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
})

router.beforeEach((to, _from, next) => {
  if (to.name !== 'SignIn' && !store.state.account.address) {
    next({ name: 'SignIn' })
  } else {
    next()
  }
})

export default router
