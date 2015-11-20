<todo>
  <add></add>
  <task each={ todo }></task>
  <script>    
    this.todo = JSON.parse(localStorage.todo || '[]')

    save() {
      /* Discard non-essential properties */
      localStorage.todo = JSON.stringify(this.todo.map(function (item) {
        return { text: item.text }
      }))
      this.update()
    }
  </script>
</todo>

<add class="row">
  <form class="large-12 columns" onsubmit="{ addItem }">
    <div class="row collapse">
      <div class="small-8 large-10 columns">
        <input type="text" onkeyup="{ addKeyPress }">
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
        e.target.value = ''
      }
    }

    addItem(e) {
      var input = e.target[0]
      if (input.value.length) {
        this.parent.todo.push({ text: input.value, edit: false })                    
        this.parent.save()
        input.value = ''
      }
    }
  </script>
</add>

<task class="row">
  <form class="large-12 columns" onsubmit="{ editSave }">
    <div class="row collapse">
      <div class="small-8 large-10 columns">
        <input type="text" value="{ text }" readonly="{ !edit }" onchange="{ e.item.text = e.target.value }" ondblclick="{ editItem }" onkeyup="{ editKeyPress }">
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
    editKeyPress(e) {
      if (e.which == 27 && e.item.edit) {
        e.target.blur()
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
        e.item.oldText = e.item.text
        var input = e.target[0] || e.target
        input.focus()
        input.select()
      } else { 
        /* Exit edit mode and save changes */
        this.parent.save()
      }
    }

    deleteCancel(e) {
      if (e.item.edit) {
        /* Exit edit mode and save changes */
        e.item.text = e.item.oldText        
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