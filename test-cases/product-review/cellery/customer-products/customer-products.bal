//   Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//   http://www.apache.org/licenses/LICENSE-2.0
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

import ballerina/io;
import celleryio/cellery;

// Salary Component
cellery:Component customersComponent = {
    name: "customers",
    source: {
        image: "celleryio/samples-productreview-customers"
    },
    ingresses: {
        customerAPI: <cellery:HttpApiIngress>{
            port:8080,
            context: "customers-1",
            definition: {
                resources: [
                    {
                        path: "/*",
                        method: "GET"
                    }
                ]
            },
            expose: "local"
        }
    },
    envVars: {
        CATEGORIES_HOST: { value: "" },
        CATEGORIES_PORT: { value: 8000 }
    }
};

cellery:Component productsComponent = {
    name: "products",
    source: {
        image: "celleryio/samples-productreview-products"
    },
    ingresses: {
        customerAPI: <cellery:HttpApiIngress>{
            port:8080,
            context: "products-1",
            definition: {
                resources: [
                    {
                        path: "/*",
                        method: "GET"
                    }
                ]
            },
            expose: "local"
        }
    }
};

cellery:Component categoriesComponent = {
    name: "categories",
    source: {
        image: "celleryio/samples-productreview-categories"
    },
    ingresses: {
        customerAPI: <cellery:GRPCIngress>{
            backendPort:8000,
            gatewayPort:8000
        }
    }
};

cellery:CellImage productCell = {
    components: {
        customers: customersComponent,
        products: productsComponent,
        categories: categoriesComponent
    }
};

public function build(cellery:ImageName iName) returns error? {
    return cellery:createImage(productCell, iName);
}

public function run(cellery:ImageName iName, map<cellery:ImageName> instances) returns error? {
    categoriesComponent.envVars.CATEGORIES_HOST.value = cellery:getHost(untaint iName.instanceName,
        categoriesComponent);
    return cellery:createInstance(productCell, iName);
}
