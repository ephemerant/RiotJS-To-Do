<todo>
  <add></add>
  <task each={ todo }></task>
  <script>    
    this.todo = JSON.parse(localStorage.todo || '[]')

    save() {
      /* Discard non-essential properties */
      localStorage.todo = JSON.stringify(this.todo.map(function (item) {
        return { text: item.text, done: item.done }
      }))
      this.update()
    }
  </script>
</todo>

<add class="row">
  <form class="large-12 columns" onsubmit="{ addItem }">
    <div class="row collapse">
      <div class="small-8 large-10 columns">
        <input type="text" name="txtTodo" onkeyup="{ addKeyPress }">
      </div>
      <div class="small-4 large-2 columns button-group expanded">
        <button class="button">
          <i class="fi-plus"></i>
        </button>
        <a class="button secondary" onclick="{ clearItem }">
          <i class="fi-x"></i>
        </a>
      </div>
    </div>
  </form>
  <script>
    addKeyPress(e) {
      if (e.which === 27) {
        this.txtTodo.value = ''
      }
    }

    addItem(e) {
      if (this.txtTodo.value.length) {
        this.parent.todo.push({ text: this.txtTodo.value, edit: false })                    
        this.parent.save()
        this.txtTodo.value = ''
      }
    }
  </script>
</add>

<task class="row">
  <form class="large-12 columns" onsubmit="{ editSave }">
    <div class="row collapse">
      <div class="small-8 large-10 columns">
        <div class="input-group">
          <div class="input-group-label">
            <input type="checkbox" checked="{ done }" onchange="{ toggleDone }">
          </div>
          <input type="text" name="txtTodo" class="input-group-field { done: done }" value="{ text }" readonly="{ !edit }" ondblclick="{ editItem }" onkeyup="{ editKeyPress }">
        </div>
      </div>
      <div class="small-4 large-2 columns button-group expanded">
        <button class="button { success: !edit }">
          <i class="{ fi-pencil: !edit, fi-check: edit }"></i>
        </button>
        <a class="button { alert: !edit, secondary: edit }" onclick="{ deleteCancel }">
          <i class="{ fi-trash: !edit, fi-x: edit }"></i>
        </a>
      </div>
    </div>
  </form>
  <script>
    toggleDone(e) {
      e.item.done = !e.item.done
      this.parent.save()
    }

    editKeyPress(e) {
      if (e.which == 27 && e.item.edit) {
        this.txtTodo.blur()
        this.deleteCancel(e)        
      }
    }

    editItem(e) {
      if (!e.item.edit) {
        /* Enter edit mode */
        this.editSave(e)
      }
    }

    editSave(e) {
      e.item.edit = !e.item.edit
      if (e.item.edit) {
        /* Enter edit mode */
        this.txtTodo.focus()
        this.txtTodo.select()
      } else { 
        /* Exit edit mode and save changes */
        e.item.text = this.txtTodo.value
        this.parent.save()
      }
    }

    deleteCancel(e) {
      if (e.item.edit) {
        /* Exit edit mode and save changes */
        this.txtTodo.value = e.item.text
        e.item.edit = false
      } else {
        /* Remove item */
        this.parent.todo = this.todo.filter(function(item) {
          return item != e.item
        })
        this.parent.save()
      }
    }
  </script>
</task>