import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select'


export default class extends Controller {
    static targets = ['switch', 'label', 'skillsDropdown', 'categoriesDropdown', 'skillTitle']
    levels = ["Nicht Bewertet", "Trainee", "Junior", "Professional", "Senior", "Expert"]
    skills = Array.from(this.hasSkillsDropdownTarget ? this.skillsDropdownTarget.options : []).map(e => { return { id: e.value, title: e.innerHTML } })


    connect() {
        if (!this.hasSkillsDropdownTarget){
            Turbo.cache.exemptPageFromCache()
            return;
        }
            

        const select = new SlimSelect({
            select: this.skillsDropdownTarget,
            events: {
                searchFilter: (option, search) => {
                    return option.text.toLowerCase().replace(/\s/g, '').indexOf(search.toLowerCase().replace(/\s/g, '')) !== -1
                },
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
        const selected_skill = this.skillsDropdownTarget.value
        const skill_category_id = this.skillsDropdownTarget.options[this.skillsDropdownTarget.selectedIndex]?.dataset.categoryId
        const all_skill_ids = this.skills.map(e => e.id)
        const is_existing_skill = all_skill_ids.includes(selected_skill)

        this.skillTitleTarget.value = newVal[0].text
        Array.from(this.categoriesDropdownTarget.parentElement.children).forEach(e => e.hidden = is_existing_skill);
        this.categoriesDropdownTarget.value = is_existing_skill ? skill_category_id : ""
    }

    unrateSkill(e) {
        e.preventDefault();
        this.setUnratedField(e, true);
        e.target.form.requestSubmit();
    }

    rateSkill(e) {
        e.preventDefault();
        this.setUnratedField(e, false);
        this.showAutoSaveMessage(e);
        e.target.form.requestSubmit();
    }

    setUnratedField(e, value) {
        const formElements = Array.from(e.target.form.elements);
        const unratedField = formElements.find(e=> e.id.startsWith("unrated-field"))
        unratedField.value = value;
    }

    showAutoSaveMessage(e) {
        const formElements = Array.from(e.target.form.elements);
        const skillId = formElements.find(e=> e.id === "people_skill_skill_id").value;
        const autoSaveMessage = document.getElementById("skill-auto-save-message-" + skillId)
        autoSaveMessage.classList.remove("visually-hidden");
    }
}