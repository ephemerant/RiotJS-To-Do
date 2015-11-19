<todo>

  <div>
    <!-- New todo -->
    <div class="row">
      <div class="large-12 columns">
        <div class="row collapse">
          <div class="small-8 large-10 columns">
            <input type="text" name="addTodo" onkeyup="{addKeyPress}">
          </div>
          <div class="small-4 large-2 columns button-group expanded">
            <a class="button" onclick="{addItem}">
              <i class="fi-plus"></i>
            </a>
            <a class="button secondary" onclick="{clearItem}">
              <i class="fi-x"></i>
            </a>
          </div>
        </div>
      </div>
    </div>

    <!-- Current todos -->
    <div class="row" each={todo}>
      <div class="large-12 columns">
        <div class="row collapse">
          <div class="small-8 large-10 columns">
            <input type="text" value="{text}" readonly="{!edit}" onchange="{textChange}" ondblclick="{editItem}" onkeyup="{editKeyPress}">
          </div>
          <div class="small-4 large-2 columns button-group expanded">
            <a class="button {success: !edit}" onclick="{editSave}">
              <i class="{fi-pencil: !edit, fi-check: edit}"></i>
            </a>
            <a class="button {alert: !edit, secondary: edit}" onclick="{deleteCancel}">
              <i class="{fi-trash: !edit, fi-x: edit}"></i>
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script>
    this.todo = [];

    if (localStorage.todo) {
      this.todo = JSON.parse(localStorage.todo)
    }

    saveToLocalStorage() {
      var clone = JSON.parse(JSON.stringify(this.todo))

      // Discard non-essential properties
      clone.forEach(function (task) {
        delete task.edit
        delete task.oldText
      })

      localStorage.todo = JSON.stringify(clone)
    }

    /* New todo */

    addKeyPress(e) {
      if (e.which === 13) {
        this.addItem(e)
      } else if (e.which === 27) {
        this.clearItem(e)
      }
    }

    addItem(e) {
      if (this.addTodo.value) {
        this.todo.push({ text: this.addTodo.value, edit: false })        
        this.clearItem(e)
        this.saveToLocalStorage()
      }
    }

    clearItem(e) {
      this.addTodo.value = ''
    }

    /* Current todos */

    textChange(e) {
      e.item.text = e.target.value
    }

    editKeyPress(e) {
      if (e.which === 13 && e.item.edit) {
        this.editSave(e)
      } else if (e.which == 27 && e.item.edit) {
        e.target.blur()
        this.deleteCancel(e)        
      }
    }

    editItem(e) {
      if (!e.item.edit) {
        // Enter edit mode
        this.editSave(e)        
      }
    }

    editSave(e) {
      e.item.edit = !e.item.edit
      if (e.item.edit) {
        // Enter edit mode
        e.item.oldText = e.item.text
        e.path[3].querySelector('input[type=text]').select()
      } else { 
        // Exit edit mode and save changes
        delete e.item.oldText
        this.saveToLocalStorage()
      }
    }

    deleteCancel(e) {
      if (e.item.edit) {
        // Exit edit mode and discard changes
        e.item.text = e.item.oldText        
        e.item.edit = false
        delete e.item.oldText
      } else {
        // Remove item
        this.todo = this.todo.filter(function(item) {
          return item != e.item
        })
        this.saveToLocalStorage()
      }
    }
  </script>

</todo>
