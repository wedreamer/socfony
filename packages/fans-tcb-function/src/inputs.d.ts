export interface CAccessOption {
    function: string;
    path: string;
    auth?: boolean;
}

export interface CPlugincInputs {
    access?: CAccessOption[];
}
