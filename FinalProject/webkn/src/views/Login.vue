<template>
    <section class="section section-shaped section-lg my-0">
        <div class="shape shape-style-1 bg-gradient-default">
            <span></span>
            <span></span>
            <span></span>
            <span></span>
            <span></span>
            <span></span>
            <span></span>
            <span></span>
        </div>
        <div class="container pt-lg-md">
            <div class="row justify-content-center">
                <div class="col-lg-5">
                    <card type="secondary" shadow
                          header-classes="bg-white pb-5"
                          body-classes="px-lg-5 py-lg-5"
                          class="border-0">
                        <template>
                            <form v-on:submit.prevent="login">
                              <h1 class="h3 mb-3 font-weight-normal">Please sign in</h1>
                              <div class="form-group">
                                <label for="email">Email address</label>
                                <input type="email" v-model="email" class="form-control" name="email" placeholder="Enter email">
                              </div>
                              <div class="form-group">
                                <label for="password">Password</label>
                                <input type="password" v-model="password" class="form-control" name="password" placeholder="Password">
                              </div>
                              <button type="submit" class="btn btn-lg btn-primary btn-block">Sign in</button>
                            </form>
                        </template>
                    </card>
                    <div class="row mt-3">
                        <div class="col-6">
                            <a href="#" class="text-light">
                                <small>Forgot password?</small>
                            </a>
                        </div>
                        <div class="col-6 text-right">
                            <a class="text-light">
                                <small>Create new account</small>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>
<script>
import axios from 'axios'
import router from '../router'
import EventBus from './EventBus'

export default {
  data () {
    return {
      email: '',
      password: ''
    }
  },

  methods: {
    login () {
      axios.post('/users/login',
        {
          email: this.email,
          password: this.password
        }
      ).then((res) => {
        localStorage.setItem('usertoken', res.data)
        this.email = ''
        this.password = ''
        if (res) {
          this.emitMethod()
          router.push({ name: 'components' })
        }
      }).catch((err) => {
        console.log(err)
      })
    },
    emitMethod () {
      EventBus.$emit('logged-in', 'loggedin')
    }
  }
}
</script>
<style>
</style>
