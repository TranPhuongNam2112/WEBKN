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
                            <div class="text-center text-muted mb-4">
                            </div>
                            <form v-on:submit.prevent="register">
                              <h1 class="h3 mb-3 font-weight-normal">Register</h1>
                                <div class="form-group">
                                  <label for="name">First name</label>
                                  <input type="text" v-model="first_name" class="form-control" name="first_name" placeholder="Enter your first name">
                                </div>
                                <div class="form-group">
                                  <label for="name">Last name</label>
                                  <input type="text" v-model="last_name" class="form-control" name="last_name" placeholder="Enter your lastname name">
                                </div>
                                <div class="form-group">
                                  <label for="email">Email address</label>
                                  <input type="email" v-model="email" class="form-control" name="email" placeholder="Enter email">
                                </div>
                                <div class="form-group">
                                  <label for="password">Password</label>
                                  <input type="password" v-model="password" class="form-control" name="password" placeholder="Password">
                                </div>
                                <button type="submit" class="btn btn-lg btn-primary btn-block">Register!</button>
                            </form>
                        </template>
                    </card>
                </div>
            </div>
        </div>
    </section>
</template>
<script>
import axios from 'axios'
import router from '../router'
export default {
  data () {
    return {
      first_name: '',
      last_name: '',
      email: '',
      password: ''
    }
  },
  methods: {
    register () {
      axios.post('/users/register',
        {
          first_name: this.first_name,
          last_name: this.last_name,
          email: this.email,
          password: this.password
        }
      ).then((res) => {
        router.push({ name: 'login' })
        console.log(res)
      }).catch((err) => {
        console.log(err)
      })
    }
  }
}

</script>
<style>
</style>
