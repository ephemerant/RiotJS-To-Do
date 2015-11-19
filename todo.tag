<todo>

  <!-- New todo -->
  <div class="row">
    <div class="large-12 columns">
      <div class="row collapse">
        <div class="small-10 columns">
          <input type="text" name="addTodo">
        </div>
        <div class="small-1 columns">
          <button class="postfix" onclick="{addItem}">
            <i class="fi-plus"></i>
          </button>
        </div>
        <div class="small-1 columns">
          <button class="secondary postfix" onclick="{clearItem}">
            <i class="fi-x"></i>
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Current todos -->
  <div class="row" each={todo}>
    <div class="large-12 columns">
      <div class="row collapse">
        <div class="small-10 columns">
          <input type="text" value="{text}" readonly="{!edit}" onchange="{textChange}" ondblclick="{editItem}">
        </div>
        <div class="small-1 columns">
          <button class="{success: !edit} postfix" onclick="{editSave}">
            <i class="{fi-pencil: !edit, fi-check: edit}"></i>
          </button>
        </div>
        <div class="small-1 columns">
          <button class="{alert: !edit, secondary: edit} postfix" onclick="{deleteCancel}">
            <i class="{fi-trash: !edit, fi-x: edit}"></i>
          </button>
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
      localStorage.todo = JSON.stringify(this.todo)
    }

    /* New todo */

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

    editItem(e) {
      if (!e.item.edit) {
        // Enter edit mode
        this.editSave(e)
        e.target.select()
      }
    }

    editSave(e) {
      e.item.edit = !e.item.edit
      if (e.item.edit) {
        // Enter edit mode
        e.item.oldText = e.item.text
      } else { 
        // Exit edit mode and save changes
        delete e.item.oldText
      }
    }

    deleteCancel(e) {
      if (e.item.edit) {
        // Exit edit mode and discard changes
        e.item.text = e.item.oldText        
        e.item.edit = false
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
