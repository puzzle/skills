import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select'


export default class extends Controller {
    static targets = ['switch', 'label', 'skillsDD', 'categoriesDD', 'skillTitle']
    levels = ["Nicht Bewertet", "Trainee", "Junior", "Professional", "Senior", "Expert"]
    skills = Array.from(this.skillsDDTarget.options).map(e => { return { id: e.value, title: e.innerHTML } })


    connect() {
        const select = new SlimSelect({
            select: this.skillsDDTarget,
            events: {
                addable: (value) => this.addNewSkill(value),
                afterChange: (newVal) => this.changeSkill(newVal)
            },
            settings: {
                searchHighlight: true,
                contentLocation: document.getElementById('dropdown-wormhole'),
                keepOrder: true,
                searchText: 'Kein Ergebnis gefunden. Um einen neuen Skill hinzuzufügen drücke auf das Plus!',
            }
        })

        this.displayLevelLabel()
        //add new selected option to select 
        if(!this.skillTitleTarget.value) return;
        let options = select.getData()
        options.push({text: this.skillTitleTarget.value})
        options = options.sort((a,b) => a.text - b.text); 
        select.setData(options)
        select.setSelected(this.skillTitleTarget.value, false)
    }

    displayLevelLabel() {
        this.labelTarget.textContent = this.levels[this.switchTarget.value]
    }

    addNewSkill(value){
        const all_skill_titles = this.skills.map(e => e.title.toLowerCase())
        if (all_skill_titles.includes(value.toLowerCase())) return false;
        return {text: value}
    }

    changeSkill(newVal) {
        const selected_skill = this.skillsDDTarget.value
        const skill_category_id = this.skillsDDTarget.options[this.skillsDDTarget.selectedIndex]?.dataset.categoryId
        const all_skill_ids = this.skills.map(e => e.id)
        const is_existing_skill = all_skill_ids.includes(selected_skill)

        this.skillTitleTarget.value = newVal[0].text
        Array.from(this.categoriesDDTarget.parentElement.children).forEach(e => e.hidden = is_existing_skill);
        this.categoriesDDTarget.value = is_existing_skill ? skill_category_id : ""
    }
}