const Sequelize = require('sequelize')
const db = require('../database/db.js')


module.exports = db.sequelize.define(
      'project',
      {
        id: {
          type: Sequelize.INTEGER,
          primaryKey: true,
          autoIncrement: true
        },
        project_title: {
          type: Sequelize.STRING
        },
        project_description: {
          type: Sequelize.STRING
        },
        goal: {
          type: Sequelize.INTEGER
        },
        current_amount: {
            type: Sequelize.INTEGER
        },
        days: {
          type: Sequelize.INTEGER
        },
        userId: {
          type: Sequelize.INTEGER,
          references: {
            model: 'user',
            key: 'id'
          }
        },
        created: {
          type: Sequelize.DATE,
          defaultValue: Sequelize.NOW
        },
        categoryId: {
          type: Sequelize.INTEGER,
          references: {
            model: 'category',
            key: 'id'
          },
          deadline: {
            type: Sequelize.DATE
          },
        }
      },
      {
        timestamps: false
      });