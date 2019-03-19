/*
 * Copyright (c) 2019 WSO2 Inc. (http:www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http:www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package main

import (
	"fmt"
	"github.com/cellery-io/sdk/components/cli/pkg/commands"
	"github.com/spf13/cobra"
)

func newSetupCreateLocalCommand() *cobra.Command {
	var isOutput bool
	var addGlobalGW bool
	var addObservability bool
	cmd := &cobra.Command{
		Use:   "local",
		Short: "Create a local Cellery runtime",
		Args:  cobra.NoArgs,
		PreRunE: func(cmd *cobra.Command, args []string) error {
			if addObservability && !addGlobalGW {
				return fmt.Errorf("You can't deploy observability portal without the Global gateway")
			}
			return nil;
		},
		Run: func(cmd *cobra.Command, args []string) {
			commands.RunSetupCreateLocal()
		},
		Example: "cellery setup create local",
	}
	cmd.Flags().BoolVarP(&addGlobalGW, "add-global-gateway", "g", false, "cellery setup create local --add-global-gateway")
	cmd.Flags().BoolVarP(&addObservability, "add-observability", "p", false, "cellery setup create local --add-global-gateway --add-observability")
	cmd.Flags().BoolVarP(&isOutput, "output", "o", false, "output")
	return cmd
}