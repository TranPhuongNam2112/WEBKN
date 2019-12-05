<template>
    <header class="header-global">
        <base-nav class="navbar-main" transparent type="" effect="light" expand>
            <router-link slot="brand" class="navbar-brand mr-lg-5" to="/">
                 <span class="nav-link-inner--text">DHA & TPN</span>
            </router-link>

            <div class="row" slot="content-header" slot-scope="{closeMenu}">
                <div class="col-6 collapse-brand">
                    <a href="https://demos.creative-tim.com/vue-argon-design-system/documentation/">
                        <img src="img/brand/blue.png">
                    </a>
                </div>
                <div class="col-6 collapse-close">
                    <close-button @click="closeMenu"></close-button>
                </div>
            </div>

             <ul class="navbar-nav navbar-nav-hover align-items-lg-center">
                
                <base-dropdown tag="li" class="nav-item" v-if="auth=='loggedin'">
                    <a slot="title" href="#" class="nav-link" data-toggle="dropdown" role="button">
                        <i class="ni ni-collection d-lg-none"></i>
                        <span class="nav-link-inner--text">Danh mục</span>
                    </a>
                    <li v-if="auth=='loggedin'" class="nav-item">
                    <router-link to="/landing" class="dropdown-item">Giáo dục</router-link>
                    </li>
                    <li v-if="auth==''" class="nav-item">
                    <router-link to="/profile" class="dropdown-item" >Kinh tế</router-link>
                    </li>
                    <router-link to="/login" class="dropdown-item" >Giải trí</router-link>
                    <router-link to="/register" class="dropdown-item">Công nghệ</router-link>
                </base-dropdown>
            </ul>
            <ul class="navbar-nav align-items-lg-center ml-lg-auto">
                <li class="nav-item">
                  <router-link class="nav-link" to="/">Home</router-link>
                </li>

                <li v-if="auth==''" class="nav-item">
                  <router-link class="nav-link" to="/login">Login</router-link>
                </li>
                <li v-if="auth==''" class="nav-item">
                  <router-link class="nav-link" to="/register">Register</router-link>
                </li>
                <li v-if="auth=='loggedin'" class="nav-item">
                  <router-link class="nav-link" to="/profile">Profile</router-link>
                </li>
                <li v-if="auth=='loggedin'" class="nav-item">
                  <a class="nav-link" href="" v-on:click="logout">Logout</a>
                </li>
            </ul>
        </base-nav>
    </header>
</template>
<script>
import BaseNav from "@/components/BaseNav";
import BaseDropdown from "@/components/BaseDropdown";
import CloseButton from "@/components/CloseButton";
import EventBus from '../views/EventBus';

EventBus.$on('logged-in', test => {
  console.log(test)
})

export default {
    
  components: {
    BaseNav,
    CloseButton,
    BaseDropdown
  },
  data () {
    return {
      auth: '',
      user: ''
    }
  },
  methods: {
    logout () {
      localStorage.removeItem('usertoken')
    }

  },
  mounted () {
    EventBus.$on('logged-in', status => {
      this.auth = status
    })
  }
};
</script>
<style>
</style>
