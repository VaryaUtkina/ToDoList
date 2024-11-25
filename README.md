# ToDoList
## Content
- [Purpose](#purpose)
- [Description](#description)
   - [Screen TaskList](#taskList)
- [Stack](#stack)

## Purpose
This project was developed as a test task for the [Effective Mobile](https://effective-mobile.ru) company.
## Description
<p>The application is designed to manage a task list.</p>
<p>When first launched, a demo task list is loaded from the network so that the user can test the functionality of the application. </p>
<p>Data is saved locally using <b>CoreData</b>. Functions for adding new tasks, editing and deleting existing ones are also available. A search for tasks by their titles and descriptions is implemented.
</p>
<p align="center">
    <img src="https://github.com/VaryaUtkina/ToDoList/blob/5067c560c04841befadf12260703229399a63f48/Assets/ToDoList_Effective_Mobile.gif" width=30% height=30%>
</p>

### Screen TaskList

<table>
<tr>
<td><img src="https://github.com/VaryaUtkina/ToDoList/blob/dff8d95dd0c7fd0aff56966343fb2546ff5faa45/Assets/TaskList.gif" width="50%" height=50%></td>
<td>
  <p>This is TaskList Screen. It is created based on <b>MVC</b> architecture.</p>
  <p>You can mark completed tasks, in which case they are marked with a check mark, and their title is crossed out.</p>
</td>
</tr>
</table>

## Stack
- VIPER
- MVC
- URLSession
- GCD
- CoreData
- UIContextMenuConfiguration
- UISearchController
- Unit tests
