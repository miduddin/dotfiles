local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
	s(
		"funtt",
		fmta(
			[[
				func Test<func>(t *testing.T) {
					t.Parallel()

					tests := []struct {
						name string
						<test_attr>
					}{
						{
							name: "ok",
						},
					}

					for _, tt := range tests {
						t.Run(tt.name, func(t *testing.T) {
							t.Parallel()

							<test_logic>
						})
					}
				}
			]],
			{
				func = i(1, "Thing"),
				test_attr = i(2, "// TODO"),
				test_logic = i(3, "// TODO"),
			}
		)
	),
	s(
		"funtth",
		fmta(
			[[
				func Test<func>(t *testing.T) {
					t.Parallel()

					tests := []struct {
						name             string
						dbData           string
						requestQuery     url.Values
						requestHeader    http.Header
						requestBody      string
						wantResponseCode int
						wantResponseBody string
					}{
						{
							name: "ok",
						},
					}

					for _, tt := range tests {
						t.Run(tt.name, func(t *testing.T) {
							t.Parallel()

							<test_setup>

							req := httptest.NewRequest(<req_method>, "<req_path>", <req_body>)
							req.URL.RawQuery = tt.requestQuery.Encode()
							req.Header = tt.requestHeader
							rec := httptest.NewRecorder()

							<test_call>

							assert.Equal(t, tt.wantResponseCode, rec.Code)
							assert.JSONEq(t, tt.wantResponseBody, rec.Body.String())
						})
					}
				}
			]],
			{
				func = i(1, "_handler_get"),
				test_setup = i(2, "// TODO"),
				req_method = i(3, "http.MethodGet"),
				req_path = i(4, "/"),
				req_body = i(5, "strings.NewReader(tt.requestBody)"),
				test_call = i(6, "// TODO"),
			}
		)
	),
}
