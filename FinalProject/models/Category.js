const Sequelize = require('sequelize')
const db = require('../database/db.js')

module.exports = () => {
  const Category = db.sequelize.define(
    'category',
    {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      category_name: {
        type: Sequelize.STRING
      },
      description: {
        type: Sequelize.STRING
      }
    },
    {
      timestamps: false
    }
  )
    //Category.associate = (models) => {
      //Category.hasMany(models.Project, {
        //foreignKey: 'categoryId',
        //onDelete: 'CASCADE'
      //})
    //};
    return Category;
  };