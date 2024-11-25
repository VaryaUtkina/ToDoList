# ToDoList
## Content
- [Purpose](#purpose)
- [Description](#description)
   - [Screen TaskList](#screen-tasklist)
   - [Screen TaskDetails](#screen-taskdetails)
- [Stack](#stack)

## Purpose
This project was developed as a test task for the [Effective Mobile](https://effective-mobile.ru) company.
## Description
<p>The application is designed to manage a task list.</p>
<p>When first launched, a demo task list is loaded from the network <b>(URLSession)</b> so that the user can test the functionality of the application. </p>
<p>Data is saved locally using <b>CoreData</b>. Also a search for tasks by their titles and descriptions is implemented.
</p>
<p align="center">
    <img src="https://github.com/VaryaUtkina/ToDoList/blob/5067c560c04841befadf12260703229399a63f48/Assets/ToDoList_Effective_Mobile.gif" width=30% height=30%>
</p>

### Screen TaskList

<table>
<tr>
<td><img src="https://github.com/VaryaUtkina/ToDoList/blob/dff8d95dd0c7fd0aff56966343fb2546ff5faa45/Assets/TaskList.gif" width="200px"></td>
<td>
  <p>This is TaskList Screen. It is based on <b>MVC</b> architecture.</p>
  <p>You can mark completed tasks, in which case they are marked with a check mark, and their title is crossed out.</p>
</td>
</tr>
<tr>
<td><img src="https://github.com/VaryaUtkina/ToDoList/blob/5f6a236a722d64642924c40d11e432cbcc6aec65/Assets/TaskList_ContextMenu.gif" width="200px"></td>
<td>
  <p>Functions for editing and deleting existing tasks are also available.</p>
</td>
</tr>
</table>

### Screen TaskDetails

<table>
<tr>
<td><img src="https://github.com/VaryaUtkina/ToDoList/blob/e0cc51a0598ff1be5e2e38e85751104395fd7101/Assets/TaskDetails.gif" width="200px"></td>
<td>
  <p>This is TaskDetails Screen. It is based on <b>VIPER</b> architecture.</p>
  <p>You can create new task or edit exicted one.</p>
</td>
</tr>
<tr>
<td><img src="https://github.com/VaryaUtkina/ToDoList/blob/5f6a236a722d64642924c40d11e432cbcc6aec65/Assets/TaskDetails_Alert.gif" width="200px"></td>
<td>
   <p>If you don't fill in the task title, then after clicking the "Готово" button, the task will not be created. An Alert will appear on the screen.</p>
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

[⬆ Go up](#todolist)
