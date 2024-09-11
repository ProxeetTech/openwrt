 

    let paginationButtons = [];

    const dataManager = {

        // Usage
        //dataManager.setData({ key: 'value' });
        //dataManager.clearData();
        //console.log(dataManager.getData());  // { key: 'value' }

        data: {},

        setData(newData) {
            this.data = newData;
        },

        clearData() {

            this.data = {};
        },

        getData() {
            return this.data;
        }
    };


    function wait_data(value){



    let wait_container = document.getElementById("px_wait_container");
    let main_mac_table = document.getElementById("main_mac_table");

        if (value) {

            wait_container.style.display = "block";
            main_mac_table.style.visibility = "hidden";

        } else {

            wait_container.style.display = "none";
            main_mac_table.style.visibility = "visible";

        }
    }


    function createPagination(totalPages, currentPage) {


        if(document.getElementById("limit_select").value === "all" ){

            return null;
        }

        paginationButtons = [];

        const pgButtonsContainer = document.getElementById("pg_buttons_container");
        if (!pgButtonsContainer) {
            console.error("Element with ID 'pg_buttons_container' not found");
            return;
        }

        pgButtonsContainer.innerHTML = "";

        const maxButtonsToShow = 5;


        if (currentPage > 1) {
            paginationButtons.push('<i class="fa-solid fa-backward"></i>');
            paginationButtons.push('<i class="fa-solid fa-chevron-left"></i>');
        }




        let startPage = Math.max(1, currentPage - Math.floor(maxButtonsToShow / 2));
        let endPage = Math.min(totalPages, startPage + maxButtonsToShow - 1);


        if (endPage - startPage + 1 < maxButtonsToShow) {
            startPage = Math.max(1, endPage - maxButtonsToShow + 1);
        }


        for (let i = startPage; i <= endPage; i++) {
            paginationButtons.push(i);
        }




        if (currentPage < totalPages) {
            paginationButtons.push('<i class="fa-solid fa-chevron-right"></i>');
            paginationButtons.push('<i class="fa-solid fa-forward"></i>');
        }






        pagination_html_gen(paginationButtons)
}

    function pagination_html_gen(paginationButtons){


        for(let paginationButton of paginationButtons ){

            addPaginationButtonToDOM(paginationButton);
        }




    }

    function paginationGo(content){

        clear_table();

        console.dir(paginationButtons);

        ////////////////////
        let table_body = document.getElementById("main_mac_table");
        console.log("Целевая страница: "+content);
        let limit_from_select = document.getElementById("limit_select").value;
        console.log("Размер страницы: "+limit_from_select);
        data = dataManager.getData();
        console.log("Общее колицество данных: "+Object.keys(data).length);
        console.log("Общее колицество страниц: "+Math.ceil(Object.keys(data).length/limit_from_select));

        let pageDevide = document.getElementById("limit_select").value;
        let totalPages = Math.ceil(Object.keys(dataManager.getData()).length / parseInt(pageDevide));

        let start;
        let limit;

        let numericArray = paginationButtons.filter(item => typeof item === 'number');
        console.log(numericArray[numericArray.length-1]);

        if(content == "last"){

            start = Object.keys(data).length - parseInt(limit_from_select);
            limit = Object.keys(data).length;




            createPagination(totalPages,totalPages);
            set_pagination_button_active(totalPages);


        }
        else if(content == "next"){

            let expected_page = (numericArray[numericArray.length-1])+1;

            if(expected_page > totalPages ){expected_page = totalPages;}

            createPagination(totalPages, expected_page);

            start = (parseInt(expected_page)-1)*parseInt(limit_from_select);
            limit = parseInt(start) + parseInt(limit_from_select);

            set_pagination_button_active(expected_page);

        }
        else if(content == "previous"){

            let expected_page = (numericArray[0])-1;

            if(expected_page < 1){expected_page = 1;}


            createPagination(totalPages, expected_page);

            start = (parseInt(expected_page)-1)*parseInt(limit_from_select);
            limit = parseInt(start) + parseInt(limit_from_select);
            set_pagination_button_active(expected_page);

        }
        else if(content == "first"){

            start = 0;
            limit = parseInt(limit_from_select);

            createPagination(totalPages,1);
            set_pagination_button_active(1);
        }
        else{

            start = (parseInt(content)-1)*parseInt(limit_from_select);
            limit = parseInt(start) + parseInt(limit_from_select);

            set_pagination_button_active(content);

        }

        console.log("start: "+start);
        console.log("limit: "+limit);


        add_cell_to_table(data,limit,start)





    }

    function addPaginationButtonToDOM(content) {


        const button = document.createElement('button');
        button.style.marginLeft = '10px';
        button.classList.add('btn');


        if (typeof content === 'string' && content.startsWith('<i')) {


            if(content.includes("fa-chevron-right")){button.setAttribute('onclick', `paginationGo("next")`);}

            else if(content.includes("fa-chevron-left")){button.setAttribute('onclick', `paginationGo("previous")`);}
            else if(content.includes("fa-backward")){button.setAttribute('onclick', `paginationGo("first")`); }

            else if(content.includes("fa-forward")){button.setAttribute('onclick', `paginationGo("last")`);}






        } else {

            button.id = "pgn_"+content;
            button.setAttribute('onclick', `paginationGo(${content})`);
        }




        if (typeof content === 'string' && content.startsWith('<i')) {
            button.innerHTML = content;
        } else {
            button.textContent = content;
        }


        document.getElementById("pg_buttons_container").appendChild(button);
    }



    function set_pagination_button_active(btn_num){


            let container = document.getElementById("pg_buttons_container");

            
            if (!container) {
                console.error("Element with ID 'pg_buttons_container' not found");
                return;
            }


            const elements = container.querySelectorAll('*');

            if(elements.length == 0){
                return null;
            }

            elements.forEach(element => {
                element.classList.remove('active-pagination-button');
                
            });

            document.getElementById("pgn_"+btn_num).classList.add("active-pagination-button");
            console.log("pgn_"+btn_num+": active-pagination-button");

            return "pgn_"+btn_num+": active-pagination-button";
    }




    function clear_field(){

        let field = document.getElementById("search");
        field.value = "";
        clear_table();
        dataManager.clearData();

        fetchData();

    }


    async function  clear_table(){

        let table_body = document.getElementById("main_mac_table");

        table_body.innerHTML = "";

    }


    function change_limit(value){

        let totalPages = Math.ceil(Object.keys(dataManager.getData()).length / value);
        let currentPage = 1;
        createPagination(totalPages, currentPage);
        set_pagination_button_active(1);
        redraw_data();
    }


   async function redraw_data(){

        console.log("call redraw");

       wait_data(true);

       await clear_table();

       await processData();

       wait_data(false);


    }


    function renew_data(){

        let table_body = document.getElementById("main_mac_table");

        table_body.innerHTML = "";

        fetchData();

    }


    function fetchData() {
    return new Promise((resolve, reject) => {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", api_endpoint, true);
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {

                    let jsonData = JSON.parse(xhr.responseText);

                    dataManager.setData(jsonData);

                    processData();
                    resolve(jsonData);
                } else {

                    reject(new Error("Failed to fetch data"));
                }
            }
        };
        xhr.send();
    });
}


async function  processData() {


        data = dataManager.getData();

        console.dir(data);
        let limit_from_select = document.getElementById("limit_select").value;

        let limit;

        if (limit_from_select === "all") {

            
            limit = Object.keys(data).length;
            console.log("tryty: "+ limit)
        } else {
            limit = parseInt(limit_from_select);
        }


        add_cell_to_table(data,limit)


    }



    function add_cell_to_table(data,limit, start = 0){

        let table_body = document.getElementById("main_mac_table");

        for (let i = start; i < limit; i++) {
            let entry = data[i];
    
            // Проверяем, существует ли элемент entry и валидные ли данные
            if (!entry) {
                console.error(`Entry at index ${i} is undefined or null`, entry);
                continue; // Пропускаем текущий элемент, если он не существует
            }
    
            let row = document.createElement("tr");
            const params = table_headers_names;
    
            params.forEach(param => {
                let cell = document.createElement("td");
    
                // Проверяем, существует ли свойство param в entry
                cell.textContent = entry[param] !== undefined ? entry[param] : 'N/A';
                row.appendChild(cell);
            });
    
            table_body.appendChild(row);
        }


    }


    document.addEventListener( 'keyup', event => {

        if( event.code === 'Enter' ) {

            search_in_data();
        }

    });


