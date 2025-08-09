local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"funtt",
		fmt(
			[[
				func Test{}(t *testing.T) {{
					t.Parallel()

					tests := []struct {{
						name string
						{}
					}}{{
						{{
							name: "ok",
						}},
					}}

					for _, tt := range tests {{
						t.Run(tt.name, func(t *testing.T) {{
							t.Parallel()

							{}
						}})
					}}
				}}
			]],
			{ i(1), i(2, "// TODO"), i(3, "// TODO") }
		)
	),
	s(
		"funtth",
		fmt(
			[[
				func Test{}(t *testing.T) {{
					t.Parallel()

					tests := []struct {{
						name             string
						dbData           string
						requestQuery     url.Values
						requestHeader    http.Header
						requestBody      string
						wantResponseCode int
						wantResponseBody string
					}}{{
						{{
							name: "ok",
						}},
					}}

					for _, tt := range tests {{
						t.Run(tt.name, func(t *testing.T) {{
							t.Parallel()

							{}

							req := httptest.NewRequest(http.MethodGet, "/", strings.NewReader(tt.requestBody))
							req.URL.RawQuery = tt.requestQuery.Encode()
							req.Header = tt.requestHeader
							rec := httptest.NewRecorder()

							{}

							assert.Equal(t, tt.wantResponseCode, rec.Code)
							assert.JSONEq(t, tt.wantResponseBody, rec.Body.String())
						}})
					}}
				}}
			]],
			{ i(1), i(2, "// TODO"), i(3, "// TODO") }
		)
	),
}
